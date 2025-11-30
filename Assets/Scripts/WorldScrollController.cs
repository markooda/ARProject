using UnityEngine;
using UnityEngine.InputSystem;

public class WorldScrollController : MonoBehaviour
{
  public PlayerGroundFollower player;

  [Header("Parallax Layers")]
  public Transform foreground;
  public Transform backgroundNear;
  public Transform backgroundFar;
  public Transform backgroundVeryFar;

  [Header("Parallax Speeds")]
  public float scrollSpeed = 5f;
  public float groundSpeed = 1f;
  public float backgroundNearSpeed = 0.5f;
  public float backgroundFarSpeed = 0.25f;
  public float backgroundVeryFarSpeed = 0.0125f;

  [Header("Movement Acceleration")]
  public float acceleration = 8f;
  public float maxSpeed = 1f;
  private float currentSpeed = 0f;

  private Vector2 moveInput;
  private float prevMoveInput = 0f;

  [Header("Look-Ahead Settings")]
  public float lookDistance = 5f;
  public float lookDuration = 0.5f;

  [Range(0f, 1f)]
  public float lookAheadThreshold = 0.8f;
  public float minTravelDistance = 1f;
  private float traveledDistance = 0f;

  private bool inLookAhead = false;
  private bool lookReturning = false;
  private float lookProgress = 0f;
  private float lookDir = 0f;

  [Header("Input Offset Settings")]
  public float inputOffsetDistance = 1f; // max distance at max speed
  public float inputOffsetDuration = 0.25f;
  private bool inputOffsetActive = false;
  private bool inputReturning = false;
  private float inputOffsetProgress = 0f;
  private float initialOffsetDir = 0f;
  private float currentPlayerOffset = 0f;

  private static MyInputs _controls;
  public static MyInputs playerControls
  {
    get { return _controls ??= new MyInputs(); }
    set { _controls = value; }
  }

  private void Awake()
  {
    playerControls.Player.Move.performed += ctx =>
    {
      player.animator.SetBool("isRunning", true);
      moveInput = ctx.ReadValue<Vector2>();

      if (moveInput.x > 0)
      {
        player.transform.localRotation = Quaternion.Euler(0f, 0f, 0f);
      }
      else if (moveInput.x < 0)
      {
        player.transform.localRotation = Quaternion.Euler(0f, 0f, 180f);
      }
    };
    playerControls.Player.Move.canceled += ctx =>
    {
      player.animator.SetBool("isRunning", false);
      moveInput = Vector2.zero;
    };
    playerControls.Player.Jump.performed += ctx =>
    {
      player.Jump();
    };

    playerControls.Player.ResetTower.performed += ctx => Cheats.Instance.ResetTower();
  }

  private void OnEnable() => playerControls.Enable();

  private void OnDisable() => playerControls.Disable();

  void Update()
  {
    // bouncy camera but doesnt really look good :(
    if (inLookAhead)
    {
      RunLookAheadPhase();
      return;
    }

    // input offset start -> init update function at the bottom
    if (prevMoveInput == 0f && Mathf.Abs(moveInput.x) > 0.01f && !player.isTouchingTower)
    {
      inputOffsetActive = true;
      inputReturning = false;
      inputOffsetProgress = 0f;
      // initialOffsetDir = -Mathf.Sign(moveInput.x); // opposite to input
      initialOffsetDir = -moveInput.x;
    }

    // input release -> return camera offset to baseline
    if (prevMoveInput != 0f && Mathf.Abs(moveInput.x) < 0.01f)
    {
      if (inputOffsetActive && !inputReturning)
      {
        inputReturning = true;
        inputOffsetProgress = 0f;
      }
    }

    // acceleration
    float inputX = -moveInput.x; // world scroll direction
    float targetSpeed = inputX * maxSpeed;

    // trigger lookaehad on release
    if (prevMoveInput != 0f && moveInput.x == 0f)
    {
      if (
        Mathf.Abs(currentSpeed) >= maxSpeed * lookAheadThreshold
        && traveledDistance >= minTravelDistance
      )
      {
        StartLookAhead(prevMoveInput > 0 ? -1f : 1f);
        traveledDistance = 0f;
      }
    }

    if (Mathf.Abs(inputX) > 0.01f)
      currentSpeed = Mathf.MoveTowards(currentSpeed, targetSpeed, acceleration * Time.deltaTime);
    else
      currentSpeed = 0f;

    // deltaX for world scrolling
    float deltaX = currentSpeed * scrollSpeed * Time.deltaTime;

    if ((deltaX > 0 && player.isCollidingRight) || (deltaX < 0 && player.isCollidingLeft))
      deltaX = 0f;

    if (player.isTouchingTower)
    {
      GameObject tower = GameObject.FindGameObjectWithTag("TowerFull");

      // rotate the tower instead of movement - fake movement
      if (Mathf.Abs(moveInput.x) > 0.01f)
      {
        Quaternion rot = tower.transform.localRotation;
        Quaternion newRot = Quaternion.Euler(
          rot.eulerAngles.x,
          rot.eulerAngles.y,
          rot.eulerAngles.z - deltaX * 20f
        );
        tower.transform.localRotation = newRot;
      }

      if (inputOffsetActive && !inputReturning)
      {
        // no way this atually worked xd
        inputReturning = true;
        inputOffsetProgress = 0f;
        // inputOffsetProgress = 0f;
        // inputOffsetActive = false;
        // inputReturning = false;
        //
        // player.transform.position += Vector3.right * -currentPlayerOffset;
        // ScrollWorld(-currentPlayerOffset);
        // currentPlayerOffset = 0f;
      }

      // TODO: create manual checkpoints for scrolling world up and down
      if (player.jumpHeight > 0f && false) // this wont work
      {
        ScrollWorldVertical(-player.jumpHeight);
        player.jumpHeight = 0f;
        player.transform.position += Vector3.up * player.jumpHeight;
      }
    }
    else
    {
      float tolerance = 0.01f;
      if (
        player.isTouchingTowerTest
        && player.justLanded
        && Mathf.Abs(player.jumpHeight) > tolerance
        && false // thisw wont work
      )
      {
        ScrollWorldVertical(-player.jumpHeight);
        // player.transform.position += Vector3.up * player.jumpHeight;
      }
      ScrollWorld(deltaX);
    }

    prevMoveInput = moveInput.x;

    // track distance for lookahead
    traveledDistance += Mathf.Abs(deltaX);

    // input offset update
    if (inputOffsetActive)
    {
      // Debug.Log("inputOffsetActive");
      inputOffsetProgress += Time.deltaTime;
      float t = Mathf.Clamp01(inputOffsetProgress / inputOffsetDuration);
      // sin curve for animation
      float easedT = Mathf.Sin(t * Mathf.PI * 0.5f);

      // scale offset by current speed
      float speedFactor = Mathf.Clamp01(Mathf.Abs(currentSpeed) / maxSpeed);
      float scaledOffsetDistance = inputOffsetDistance * speedFactor;

      float offsetTarget = inputReturning ? 0f : initialOffsetDir * scaledOffsetDistance;
      float newOffset = Mathf.Lerp(currentPlayerOffset, offsetTarget, easedT);
      float offsetDelta = newOffset - currentPlayerOffset;

      // move player
      player.transform.position += Vector3.right * offsetDelta;

      // move world during both start and return
      ScrollWorld(offsetDelta);

      currentPlayerOffset = newOffset;

      if ((t >= 1f && inputReturning))
      {
        Debug.Log("Returning");
        inputOffsetActive = false;
        inputReturning = false;
        currentPlayerOffset = 0f;
      }
    }
  }

  private void StartLookAhead(float dir)
  {
    inLookAhead = true;
    lookReturning = false;
    lookProgress = 0f;
    lookDir = dir;
  }

  private void RunLookAheadPhase()
  {
    lookProgress += Time.deltaTime;
    float t = Mathf.Clamp01(lookProgress / lookDuration);

    float deltaX;
    if (!lookReturning)
    {
      // ease out
      float easedT = Mathf.Sin(t * Mathf.PI);
      deltaX = lookDir * lookDistance * easedT * (Time.deltaTime / lookDuration);
    }
    else
    {
      // returning at constant speed
      deltaX = lookDir * lookDistance * (Time.deltaTime / lookDuration);
      deltaX *= -1f; // move back
    }

    ScrollWorld(deltaX);
    player.transform.position += Vector3.right * deltaX;

    if (lookProgress >= lookDuration)
    {
      if (!lookReturning)
      {
        lookReturning = true;
        lookProgress = 0f;
      }
      else
      {
        inLookAhead = false;
        lookReturning = false;
      }
    }
  }

  // parallax
  private void ScrollWorld(float deltaX)
  {
    if (foreground != null)
      foreground.position += Vector3.right * deltaX * groundSpeed;

    if (backgroundNear != null)
      backgroundNear.position += Vector3.right * deltaX * backgroundNearSpeed;

    if (backgroundFar != null)
      backgroundFar.position += Vector3.right * deltaX * backgroundFarSpeed;

    if (backgroundVeryFar != null)
      backgroundVeryFar.position += Vector3.right * deltaX * backgroundVeryFarSpeed;
  }

  private void ScrollWorldVertical(float deltaX)
  {
    if (foreground != null)
      foreground.position += Vector3.up * deltaX * groundSpeed;

    if (backgroundNear != null)
      backgroundNear.position += Vector3.up * deltaX * groundSpeed;

    if (backgroundFar != null)
      backgroundFar.position += Vector3.up * deltaX * groundSpeed;

    if (backgroundVeryFar != null)
      backgroundVeryFar.position += Vector3.up * deltaX * groundSpeed;
  }
}
