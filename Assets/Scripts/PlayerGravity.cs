using System.Collections;
using TMPro;
using UnityEngine;

public class PlayerGroundFollower : MonoBehaviour
{
  public InputsAPI Inputs { get; private set; }

  [Header("DebugUI")]
  public TextMeshProUGUI textUi;

  [Header("Animator")]
  public Animator animator;

  [Header("Player Settings")]
  public float playerHeight = 1.8f; // vertical size along Y
  public float playerRadius = 0.3f; // capsule cast radius
  public float stepSmooth = 10f; // smoothing for vertical movement
  public float rayLength = 1.0f; // ground check length
  public float movementSpeed = 3f;
  private float baseMovementSpeed;
  private Vector3 startPos;

  [Header("Collision Settings")]
  public LayerMask groundLayer;
  public LayerMask wallLayer;
  public float wallCheckDistance = 0.1f;

  [Header("Jump Settings")]
  public float jumpForce = 5f;
  public float gravity = 20f;

  private float verticalVelocity = 0f;
  public bool isJumping { get; private set; }

  [Header("Airborne Settings")]
  public float airborneTolerance = 0.2f;

  private float playerY = 0f;
  private float hitY = 0f;

  public TowerPlatform currPlatform { get; private set; }

  public bool isGrounded { get; private set; }
  public bool wasGrounded { get; private set; }
  public bool isAirborne { get; private set; }

  public bool isCollidingLeft { get; private set; }
  public bool isCollidingRight { get; private set; }
  public bool willCollideLeft { get; private set; }
  public bool willCollideRight { get; private set; }

  [Header("World Reference")]
  public Transform world;

  [Header("Game State")]
  public GameState gameState;

  [Header("Testing")]
  public bool isTouchingTower { get; private set; }
  public bool isTouchingTowerTest { get; private set; }

  public float playerY_Begin { get; private set; }
  public float playerY_End { get; private set; }

  public float lastDeltaY { get; private set; }

  public float accumulatedYAirMovement { get; private set; }

  [Header("Attack Settings")]
  public bool isAttacking;
  public float attackDelay = 0.5f;
  public int damage = 50;

  private int prevAttack = 0;

  public int attackId { get; private set; }
  public bool isBlocking { get; private set; }

  public int hitPoints { get; private set; }
  private bool isDead;

  // offset from initial position

  private float playerPositionX;
  public float playerOffsetX { get; private set; }

  public void TakeDamage(int damage)
  {
    hitPoints -= damage;
    Debug.Log("Player hitpoints: " + hitPoints);
    if (hitPoints <= 0)
    {
      Debug.Log("Player dead");
      isDead = true;
    }
  }

  public void Reset()
  {
    hitPoints = 100;
    transform.position = startPos;
    isDead = false;
  }

  void Start()
  {
    playerY_Begin = 0f;
    playerY_End = 0f;
    lastDeltaY = 0f;
    isJumping = false;
    isGrounded = false;
    wasGrounded = false;
    isAttacking = false;
    isBlocking = false;
    hitPoints = 100;
    Inputs = new InputsAPI(this);
    currPlatform = null;
    playerPositionX = transform.position.x;
    playerOffsetX = 0f;
    baseMovementSpeed = movementSpeed;
    startPos = transform.position;
  }

  void FixedUpdate()
  {
    textUi.text =
      "isAirborne: "
      + isAirborne
      + "\nIsGrounded: "
      + isGrounded
      + "\nWasGrounded: "
      + wasGrounded
      + "\nPlayerY: "
      + playerY
      + "\nHitY: "
      + hitY
      + "\nLastDeltaY: "
      + lastDeltaY
      + "\nPlayerOffsetX: "
      + playerOffsetX;

    if (isDead)
    {
      gameState.ResetGame();
      return;
    }

    // var animationLength = animator.GetCurrentAnimatorStateInfo(0).length;
    // Debug.Log("animationLength: " + animationLength);
    // start of the update

    // calculate offset from initial position
    playerOffsetX = transform.position.x - playerPositionX;

    wasGrounded = isGrounded;

    if (isJumping)
    {
      JumpUpdate();
    }
    else
    {
      FollowGround();
    }

    if (wasGrounded && isAirborne)
    {
      playerY_Begin = transform.position.y;
    }

    if (isGrounded && !wasGrounded)
    {
      playerY_End = transform.position.y;
      lastDeltaY = playerY_End - playerY_Begin;
    }

    CheckWalls();
  }

  // Debug for the capusle collider draws sphere on top and at the bottom
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
    willCollideLeft = false;
    willCollideRight = false;

    Vector3 pos = transform.position;

    float halfSegment = Mathf.Max(0.0001f, (playerHeight * 0.5f) - playerRadius);
    Vector3 top = pos + Vector3.up * halfSegment;
    Vector3 bottom = pos - Vector3.up * halfSegment;

    const float skinWidth = 0.05f;

    Vector3 startOffset = Vector3.zero;

    // LEFT direction check
    Vector3 dirLeft = Vector3.left;
    Collider[] overlapsLeft = Physics.OverlapCapsule(top, bottom, playerRadius, wallLayer);
    foreach (var col in overlapsLeft)
    {
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

      if (
        Physics.CapsuleCast(
          top,
          bottom,
          playerRadius,
          dirLeft,
          out RaycastHit hitLeft2,
          wallCheckDistance + 0.25f,
          wallLayer
        )
      )
      {
        willCollideLeft = true;
        Debug.Log("Will collide left, should stop scrolling");
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

      if (
        Physics.CapsuleCast(
          top,
          bottom,
          playerRadius,
          dirRight,
          out RaycastHit hitRight2,
          wallCheckDistance + 0.25f,
          wallLayer
        )
      )
      {
        willCollideRight = true;
        Debug.Log("Will collide right, should stop scrolling");
      }
    }

    // This is not good because it does not offset the world
    // Player goes out of center
    // solved by calculating player offset and unscrolling the world in world scroll controller
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
    Vector3 castDir = Vector3.down;
    const float skinWidth = 0.05f;
    float halfSegment = Mathf.Max(0.0001f, (playerHeight * 0.5f) - playerRadius);

    Vector3 capsuleTop = pos + Vector3.up * halfSegment;
    Vector3 capsuleBottom = pos - Vector3.up * halfSegment;

    Vector3 startOffset = -castDir.normalized * skinWidth;
    capsuleTop += startOffset;
    capsuleBottom += startOffset;

    float maxDistance = rayLength + skinWidth;

    Debug.DrawLine(capsuleTop, capsuleBottom, Color.yellow);

    Collider[] overlaps = Physics.OverlapCapsule(
      capsuleTop,
      capsuleBottom,
      playerRadius,
      groundLayer
    );

    currPlatform = null;

    if (overlaps != null && overlaps.Length > 0)
    {
      transform.position += Vector3.up * (skinWidth + 0.01f);
      isAirborne = false;
      isGrounded = true;

      // tower is a special case for world controller
      foreach (var col in overlaps)
      {
        Debug.Log(
          $"Hit collider: {col.name} | parent: {col.transform.parent?.name} | root: {col.transform.root.name}"
        );
        var platform =
          col.GetComponent<TowerPlatform>()
          ?? col.GetComponentInParent<TowerPlatform>()
          ?? col.GetComponentInChildren<TowerPlatform>();
        // var platform = col.gameObject.GetComponent<TowerPlatform>();
        if (platform != null)
        {
          currPlatform = platform;
        }

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
      var platform =
        hit.transform.GetComponent<TowerPlatform>()
        ?? hit.transform.GetComponentInParent<TowerPlatform>()
        ?? hit.transform.GetComponentInChildren<TowerPlatform>();

      if (platform != null)
      {
        currPlatform = platform;
      }

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

      playerY = transform.position.y;
      hitY = hit.point.y;

      if (transform.position.y - hit.point.y > airborneTolerance)
      {
        isGrounded = false;
        isAirborne = true;
      }
      else
      {
        isGrounded = true;
        isAirborne = false;
      }

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
      isAirborne = true;
      verticalVelocity = jumpForce;
      Debug.Log("Jump enabled");
    }
  }

  // parabolic jump
  public void JumpUpdate()
  {
    verticalVelocity -= gravity * Time.fixedDeltaTime;
    isGrounded = false;

    Vector3 pos = transform.position;
    pos.y += verticalVelocity * Time.fixedDeltaTime;
    transform.position = pos;

    Vector3 rayStart = transform.position - Vector3.up * (playerHeight / 2 - 0.05f);
    Vector3 capsuleBottom = transform.position - Vector3.up * (playerHeight / 2);
    Vector3 capsuleTop = transform.position + Vector3.up * (playerHeight / 2);

    // just landed
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
      isAirborne = false;
      isGrounded = true;

      animator.SetBool("isJumping", false);
    }
  }

  private void PerformAttack()
  {
    IEnumerator ResetAttack()
    {
      yield return new WaitUntil(() => animator.GetCurrentAnimatorStateInfo(0).IsName("Attack"));

      var state = animator.GetCurrentAnimatorStateInfo(0);
      Debug.Log("Attack animation duration: " + state.length / state.speed);

      yield return new WaitForSeconds(state.length / state.speed);

      isAttacking = false;
    }

    if (isAttacking)
      return;

    Debug.Log("attack performed");
    int attackType;
    do
    {
      attackType = Random.Range(0, 3);
    } while (attackType == prevAttack);
    prevAttack = attackType;
    animator.SetFloat("attackType", attackType);
    animator.SetTrigger("attack");
    isAttacking = true;
    attackId++;

    AnimatorStateInfo state = animator.GetCurrentAnimatorStateInfo(0);

    StartCoroutine(ResetAttack());
  }

  private void StartRunning(float speed)
  {
    animator.SetBool("isRunning", true);

    if (speed > 0)
    {
      transform.localRotation = Quaternion.Euler(0f, 0f, 0f);
    }
    else if (speed < 0)
    {
      transform.localRotation = Quaternion.Euler(0f, 0f, 180f);
    }
  }

  private void StopRunning()
  {
    animator.SetBool("isRunning", false);
    animator.SetBool("isRunningFast", false);
  }

  private void PerformBlock()
  {
    IEnumerator ResetBlock()
    {
      yield return new WaitUntil(() => animator.GetCurrentAnimatorStateInfo(0).IsName("Block"));

      var state = animator.GetCurrentAnimatorStateInfo(0);
      Debug.Log("Block animation duration: " + state.length / state.speed);

      yield return new WaitForSeconds(state.length / state.speed);

      isBlocking = false;
    }

    Debug.Log("block performed");
    animator.SetTrigger("block");
    isBlocking = true;

    StartCoroutine(ResetBlock());
  }

  public bool RestoreHealth(int amount)
  {
    if (hitPoints == 100)
      return false;

    hitPoints = Mathf.Clamp(hitPoints + amount, 0, 100);
    return true;
  }

  public void IncreaseDamage(int amount)
  {
    damage += amount;
  }

  public void IncreaseMovementSpeed(float amount, int duration)
  {
    IEnumerator IncreaseMSRoutine()
    {
      movementSpeed += amount;
      yield return new WaitForSeconds(duration);
      movementSpeed -= amount;
    }
    StartCoroutine(IncreaseMSRoutine());
  }

  public sealed class InputsAPI
  {
    private readonly PlayerGroundFollower p;

    internal InputsAPI(PlayerGroundFollower player) => p = player;

    public void PerformAttack() => p.PerformAttack();

    public void StartRunning(float speed) => p.StartRunning(speed);

    public void StopRunning() => p.StopRunning();

    public void PerformBlock() => p.PerformBlock();

    public void PerformJump() => p.Jump();
  }
}
