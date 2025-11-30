using UnityEngine;

public class PlayerGroundFollower : MonoBehaviour
{
  [Header("Animator")]
  public Animator animator;

  [Header("Player Settings")]
  public float playerHeight = 1.8f; // vertical size along Y
  public float playerRadius = 0.3f; // capsule cast radius
  public float stepSmooth = 10f; // smoothing for vertical movement
  public float rayLength = 1.0f; // ground check length

  [Header("Collision Settings")]
  public LayerMask groundLayer;
  public LayerMask wallLayer;
  public float wallCheckDistance = 0.1f;

  [Header("Jump Settings")]
  public float jumpForce = 5f;
  public float gravity = 20f;

  private float verticalVelocity = 0f;
  public bool isJumping { get; private set; }

  // ok fuck thisc
  public bool isGrounded { get; private set; }
  public bool wasGrounded { get; private set; }
  public bool justLanded { get; private set; }

  public bool isCollidingLeft { get; private set; }
  public bool isCollidingRight { get; private set; }

  [Header("World Reference")]
  public Transform world;

  public bool isTouchingTower { get; private set; }
  public bool isTouchingTowerTest { get; private set; }

  public float elevation { get; private set; }
  public float jumpHeight { get; set; }

  public float accumulatedYAirMovement { get; private set; }

  void Start()
  {
    elevation = transform.position.y;
    jumpHeight = 0f;
    isJumping = false;
  }

  void FixedUpdate()
  {
    wasGrounded = isGrounded;
    float oldY = transform.position.y;

    if (!isGrounded)
    {
      float deltaY = transform.position.y - oldY;
      accumulatedYAirMovement += deltaY;
    }

    if (justLanded)
    {
      jumpHeight = accumulatedYAirMovement;
      accumulatedYAirMovement = 0f;
    }

    justLanded = false;
    if (isJumping)
    {
      JumpUpdate();
    }
    else
    {
      FollowGround();
    }

    // TowerElevationUpdate();
    // Debug.Log("isTouchingTower: " + isTouchingTower);

    CheckWalls();

    // float newY = transform.position.y;
    // float deltaY = newY - oldY;
    //
    // Debug.Log("deltaY: " + deltaY);
    // Debug.Log("isGrounded: " + isGrounded);
    //
    // jumpHeight = deltaY;
    // elevation = newY;
  }

  void OnDrawGizmos()
  {
    if (!Application.isPlaying)
      return;

    Vector3 bottom = transform.position - Vector3.up * (playerHeight / 2);
    Vector3 top = transform.position + Vector3.up * (playerHeight / 2);

    Gizmos.color = Color.yellow;
    Gizmos.DrawWireSphere(top, playerRadius);
    Gizmos.DrawWireSphere(bottom, playerRadius);
    Gizmos.DrawLine(top, bottom);
  }

  private void CheckWalls()
  {
    isCollidingLeft = false;
    isCollidingRight = false;

    Vector3 pos = transform.position;

    // Capsule endpoints
    float halfSegment = Mathf.Max(0.0001f, (playerHeight * 0.5f) - playerRadius);
    Vector3 top = pos + Vector3.up * halfSegment;
    Vector3 bottom = pos - Vector3.up * halfSegment;

    // Small buffer to avoid starting inside geometry
    const float skinWidth = 0.05f;

    // Move capsule slightly backward for cast start
    Vector3 startOffset = Vector3.zero; // horizontal check doesn't require nudge usually

    // LEFT direction check
    Vector3 dirLeft = Vector3.left;
    Collider[] overlapsLeft = Physics.OverlapCapsule(top, bottom, playerRadius, wallLayer);
    foreach (var col in overlapsLeft)
    {
      // Check if collider is to the left
      if (col.bounds.max.x >= pos.x - playerRadius)
      {
        isCollidingLeft = true;
        break;
      }
    }

    if (!isCollidingLeft)
    {
      if (
        Physics.CapsuleCast(
          top,
          bottom,
          playerRadius,
          dirLeft,
          out RaycastHit hitLeft,
          wallCheckDistance,
          wallLayer
        )
      )
      {
        isCollidingLeft = true;
        Debug.DrawLine(pos, pos + dirLeft * wallCheckDistance, Color.red);
      }
    }

    // RIGHT direction check
    Vector3 dirRight = Vector3.right;
    Collider[] overlapsRight = Physics.OverlapCapsule(top, bottom, playerRadius, wallLayer);
    foreach (var col in overlapsRight)
    {
      // Check if collider is to the right
      if (col.bounds.min.x <= pos.x + playerRadius)
      {
        isCollidingRight = true;
        break;
      }
    }

    if (!isCollidingRight)
    {
      if (
        Physics.CapsuleCast(
          top,
          bottom,
          playerRadius,
          dirRight,
          out RaycastHit hitRight,
          wallCheckDistance,
          wallLayer
        )
      )
      {
        isCollidingRight = true;
        Debug.DrawLine(pos, pos + dirRight * wallCheckDistance, Color.blue);
      }
    }

    if (isCollidingLeft)
    {
      transform.position += Vector3.right * (skinWidth + 0.01f);
    }

    if (isCollidingRight)
    {
      transform.position += Vector3.left * (skinWidth + 0.01f);
    }
  }

  private void FollowGround()
  {
    Vector3 pos = transform.position;

    // Direction that represents 'down' in your side view
    Vector3 castDir = Vector3.down;

    // Small buffer to avoid starting the cast *inside* geometry
    const float skinWidth = 0.05f;

    // Compute the half distance between the sphere centers (line segment length)
    // for Unity capsule APIs the two points are the centers of the end-spheres,
    // so halfSegment = (playerHeight/2) - playerRadius
    float halfSegment = Mathf.Max(0.0001f, (playerHeight * 0.5f) - playerRadius);

    // Points at the centers of the capsule end-spheres (before offset)
    Vector3 capsuleTop = pos + Vector3.up * halfSegment;
    Vector3 capsuleBottom = pos - Vector3.up * halfSegment;

    // Offset the capsule *opposite* the cast direction so the sweep starts slightly above
    // (castDir is back, so -castDir is forward)
    Vector3 startOffset = -castDir.normalized * skinWidth;
    capsuleTop += startOffset;
    capsuleBottom += startOffset;

    // Sweep distance: how far down we'll check. include skinWidth to account for offset
    float maxDistance = rayLength + skinWidth;

    Debug.DrawLine(capsuleTop, capsuleBottom, Color.yellow);

    // First: handle the overlapping case (capsule currently intersecting ground)
    Collider[] overlaps = Physics.OverlapCapsule(
      capsuleTop,
      capsuleBottom,
      playerRadius,
      groundLayer
    );

    if (overlaps != null && overlaps.Length > 0)
    {
      // We're already intersecting ground — nudge the player up a bit so we are above it.
      // This prevents the sweep from skipping the collider.
      // Debug.Log("Colliding due to overlaps");
      transform.position += Vector3.up * (skinWidth + 0.01f);
      isGrounded = true;
      isJumping = false;

      if (!wasGrounded && isGrounded)
      {
        // We just transitioned AIR → GROUND
        justLanded = true;

        // Compute vertical delta, good for world-scrolling
        jumpHeight = transform.position.y - elevation;
        elevation = transform.position.y;
      }
      // tower is a special case for world controller
      foreach (var col in overlaps)
      {
        if (col.gameObject.tag == "TowerTest")
        {
          isTouchingTowerTest = true;
          return;
        }
        if (col.gameObject.tag == "Tower")
        {
          isTouchingTower = true;
          return;
        }
      }

      isTouchingTower = false;
      isTouchingTowerTest = false;
      return;
    }
    else
    {
      isGrounded = false;
    }

    // Now perform the capsule sweep DOWN
    if (
      Physics.CapsuleCast(
        capsuleTop,
        capsuleBottom,
        playerRadius,
        castDir,
        out RaycastHit hit,
        maxDistance,
        groundLayer
      )
    )
    {
      if (hit.transform.tag == "Tower")
      {
        isTouchingTower = true;
      }
      else
      {
        isTouchingTower = false;
      }

      if (hit.transform.tag == "TowerTest")
      {
        isTouchingTowerTest = true;
      }
      else
      {
        isTouchingTowerTest = false;
      }
      // Debug.Log("Colliding due to capsulecast");
      // hit.distance is from the *start offset* — compute ground Z
      // hit.point is valid; we want the player's bottom to sit at hit.point.z
      isGrounded = true;
      isJumping = false;
      float targetY = hit.point.y + (playerHeight / 2f);

      Vector3 newPos = pos;
      newPos.y = Mathf.MoveTowards(pos.y, targetY, stepSmooth * Time.fixedDeltaTime);
      transform.position = newPos;

      Debug.DrawRay(hit.point, Vector3.up * 0.1f, Color.green);
    }
    else
    {
      isGrounded = false;
    }
  }

  public void Jump()
  {
    if (!isJumping)
    {
      animator.SetBool("isJumping", true); // handle this here so that i can check if player is not already mid air
      isJumping = true;
      isGrounded = false;
      verticalVelocity = jumpForce;
      Debug.Log("Jump enabled");
    }
  }

  // parabolic jump
  public void JumpUpdate()
  {
    // Apply gravity
    verticalVelocity -= gravity * Time.fixedDeltaTime;

    if (verticalVelocity > 0f)
    {
      isGrounded = false;
    }

    // Move the player
    Vector3 pos = transform.position;
    pos.y += verticalVelocity * Time.fixedDeltaTime;
    transform.position = pos;

    // Raycast from player bottom
    Vector3 rayStart = transform.position - Vector3.up * (playerHeight / 2 - 0.05f);

    // Only check landing when falling
    Vector3 capsuleBottom = transform.position - Vector3.up * (playerHeight / 2);
    Vector3 capsuleTop = transform.position + Vector3.up * (playerHeight / 2);

    if (
      verticalVelocity <= 0
      && Physics.CapsuleCast(
        capsuleTop,
        capsuleBottom,
        playerRadius,
        Vector3.down,
        out RaycastHit hit,
        Mathf.Abs(verticalVelocity * Time.fixedDeltaTime) + 0.1f,
        groundLayer
      )
    )
    {
      float groundY = hit.point.y + playerHeight / 2;
      pos.y = groundY;
      transform.position = pos;

      verticalVelocity = 0f;
      isJumping = false;
      isGrounded = true;
      animator.SetBool("isJumping", false);

      if (!wasGrounded && isGrounded)
      {
        // We just transitioned AIR → GROUND
        justLanded = true;

        // Compute vertical delta, good for world-scrolling
        jumpHeight = transform.position.y - elevation;
        elevation = transform.position.y;
      }
    }
  }

  // public void TowerElevationUpdate()
  // {
  //   Debug.Log("isTouchingTowerTest: " + isTouchingTowerTest);
  //   Debug.Log("jumpHeight: " + (transform.position.y - elevation));
  //   Debug.Log("elevation: " + elevation);
  //   Debug.Log("transform.position.y: " + transform.position.y);
  //   if (true)
  //   {
  //     // float playerY = transform.position.y;
  //     // float groundY = playerY + playerHeight / 2;
  //     float groundY = transform.position.y;
  //     jumpHeight = groundY - elevation;
  //     Debug.Log("jumpHeight: " + jumpHeight);
  //     elevation = groundY;
  //   }
  // }
}
