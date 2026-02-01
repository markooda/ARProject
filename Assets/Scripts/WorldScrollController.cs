using System.Collections;
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
  public Transform baseGround;

  [Header("Parallax Speeds")]
  public float groundSpeed = 1f;
  public float backgroundNearSpeed = 0.5f;
  public float backgroundFarSpeed = 0.25f;
  public float backgroundVeryFarSpeed = 0.0125f;
  public float backgroundVeryFarVerticalSpeed = 0.4f;
  private float scrollSpeed;

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

  private float lastMoveTime = 0f;

  [Header("Tower Platform Settings")]
  public float scrollSpeedVertical = 5f;
  private float currentLevelZ = 0f;
  private float targetLevelZ = 0f;

  private TowerPlatform lastPlatform = null;

  private static MyInputs _controls;
  public static MyInputs playerControls
  {
    get { return _controls ??= new MyInputs(); }
    set { _controls = value; }
  }

  private void Awake()
  {
    scrollSpeed = player.movementSpeed;

    playerControls.Player.Move.performed += ctx =>
    {
      moveInput = ctx.ReadValue<Vector2>();
      player.Inputs.StartRunning(moveInput.x);
    };
    playerControls.Player.Move.canceled += ctx =>
    {
      player.Inputs.StopRunning();
      moveInput = Vector2.zero;
    };
    playerControls.Player.Jump.performed += ctx =>
    {
      player.Inputs.PerformJump();
    };

    playerControls.Player.Attack.performed += ctx =>
    {
      player.Inputs.PerformAttack();
    };

    playerControls.Player.Block.performed += ctx =>
    {
      player.Inputs.PerformBlock();
    };

    playerControls.Player.ResetGameObjects.performed += ctx => Cheats.Instance.ResetGameObjects();
    playerControls.Player.CenterPlayer.performed += ctx => Cheats.Instance.CenterPlayer();
  }

  private void OnEnable() => playerControls.Enable();

  private void OnDisable() => playerControls.Disable();

  void FixedUpdate()
  {
    // moved speed control to player
    if (!Mathf.Approximately(scrollSpeed, player.movementSpeed))
    {
      scrollSpeed = player.movementSpeed;
    }
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
    if (
      (prevMoveInput != 0f && Mathf.Abs(moveInput.x) < 0.01f)
      || player.willCollideLeft
      || player.willCollideRight
    )
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
    {
      currentSpeed = Mathf.MoveTowards(
        currentSpeed,
        targetSpeed,
        acceleration * Time.fixedDeltaTime
      );

      lastMoveTime = Time.time;
    }
    else
      currentSpeed = 0f;

    // fix for bug where player gets offset from initial position due to collider overlap correction
    float offsetX = player.playerOffsetX;
    if (
      Time.time - lastMoveTime > 0.5f
      && Mathf.Abs(offsetX) > 0.01f
      && !inputReturning
      && currentPlayerOffset == 0f
    )
    {
      Debug.Log("offsetX: " + offsetX);
      float maxStep = maxSpeed * Time.fixedDeltaTime;
      float newOffsetX = Mathf.MoveTowards(offsetX, 0f, maxStep);
      float step = newOffsetX - offsetX;

      player.transform.position += Vector3.right * step;
      ScrollWorld(step);
    }

    // switch animation to fast running
    if (Mathf.Abs(currentSpeed) > maxSpeed / 2)
    {
      player.animator.SetBool("isRunningFast", true);
    }
    else
    {
      player.animator.SetBool("isRunningFast", false);
    }

    // deltaX for world scrolling
    float deltaX = currentSpeed * scrollSpeed * Time.fixedDeltaTime;

    if ((deltaX < 0 && player.willCollideRight) || (deltaX > 0 && player.willCollideLeft))
    {
      deltaX = 0f;
      // allow player to build up momentum while running against a wall for easier jumps
      // but obly to one third of max allowed speed
      currentSpeed = Mathf.Min(currentSpeed, maxSpeed * 0.3f);
      Debug.Log("World scroller player soon colliding");
    }

    TowerMovementVertical();

    if (player.isTouchingTower)
    {
      GameObject tower = GameObject.FindGameObjectWithTag("TowerFull");
      Debug.Log("Tower found: " + tower);

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

        Debug.Log("Rotating tower??");
      }

      if (inputOffsetActive && !inputReturning)
      {
        // no way this atually worked xd
        inputReturning = true;
        inputOffsetProgress = 0f;
      }
    }
    else
    {
      ScrollWorld(deltaX);
    }

    prevMoveInput = moveInput.x;

    // track distance for lookahead
    traveledDistance += Mathf.Abs(deltaX);

    // input offset update
    if (inputOffsetActive)
    {
      // Debug.Log("inputOffsetActive");
      inputOffsetProgress += Time.fixedDeltaTime;
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
    lookProgress += Time.fixedDeltaTime;
    float t = Mathf.Clamp01(lookProgress / lookDuration);

    float deltaX;
    if (!lookReturning)
    {
      // ease out
      float easedT = Mathf.Sin(t * Mathf.PI);
      deltaX = lookDir * lookDistance * easedT * (Time.fixedDeltaTime / lookDuration);
    }
    else
    {
      // returning at constant speed
      deltaX = lookDir * lookDistance * (Time.fixedDeltaTime / lookDuration);
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

  private void TowerMovementVertical()
  {
    TowerPlatform p = player.currPlatform; // this is the one you set from capsulecast/overlap

    if (p != lastPlatform)
    {
      lastPlatform = p;

      if (p != null)
      {
        targetLevelZ = p.GetLevelZ(foreground, baseGround); // platform level relative to base ground
      }
      else
      {
        targetLevelZ = 0f; // back to base ground level
      }
    }

    // Now move only if not already at target:
    float diff = targetLevelZ - currentLevelZ;
    if (Mathf.Abs(diff) < 0.001f)
      return;

    float speed = scrollSpeedVertical;
    if (!player.isAirborne || player.isGrounded)
      speed *= 0.2f;

    float step = Mathf.Sign(diff) * speed * Time.fixedDeltaTime;
    if (Mathf.Abs(step) > Mathf.Abs(diff))
      step = diff;

    // Move world opposite direction to align the platform down to base level
    ScrollWorldVertical(-step);

    currentLevelZ += step;
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
    float speed = groundSpeed;

    if (foreground != null)
      foreground.position += Vector3.up * deltaX * speed;

    if (backgroundNear != null)
      backgroundNear.position += Vector3.up * deltaX * speed;

    if (backgroundFar != null)
      backgroundFar.position += Vector3.up * deltaX * speed;

    if (backgroundVeryFar != null)
      backgroundVeryFar.position += Vector3.up * deltaX * backgroundVeryFarVerticalSpeed;
  }
}
