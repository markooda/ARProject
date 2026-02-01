using System.Collections;
using UnityEngine;

public class SkeletonController : EnemyController
{
  private Transform player;

  // private Rigidbody rb;
  [Header("Animation")]
  private Animator animator;
  public float turnSpeed = 540f;

  [Header("Hit detection")]
  public float hitCooldown = 1f;

  private CharacterController cc;

  [Header("Patrol")]
  // public float patrolDistance = 4f;
  public float speed = 2f;

  [Header("Gravity")]
  public float gravity = -20f;
  private float verticalVelocity = 0f;

  private Vector3 startPos;
  private int dir = 1;
  private float pause = 0f;

  public bool isMoving { get; private set; }

  private PatrolBound currentBound;

  [Header("Combat")]
  public float attackRange = 1.5f;
  public float verticalTolerance = 2.5f;
  public float attackDelay = 0.5f;
  private float attackCooldown = 0f;

  public bool isAttacking { get; private set; } = false;
  private bool isDying;
  public int attackId { get; private set; } = 0;

  public override void Reset()
  {
    gameObject.SetActive(true);
    transform.position = startPos;
    hitPoints = 100;
    isDying = false;
    animator.Rebind();
    animator.Update(0f);
  }

  // Start is called once before the first execution of Update after the MonoBehaviour is created
  void Awake()
  {
    cc = GetComponent<CharacterController>();
    animator = GetComponentInChildren<Animator>();
    startPos = transform.position;
    isMoving = false;
    isDying = false;
    player = GameObject.FindGameObjectWithTag("Player").transform;
  }

  // Update is called once per frame
  void Update()
  {
    if (isDying)
      return;

    animator.SetBool("isMoving", isMoving);
    float horizontalVelocity = dir * speed;

    bool attacked = TryAttack();

    if (pause > 0f)
    {
      pause = Mathf.Max(pause - Time.deltaTime, 0f);
      horizontalVelocity = 0f;
      isMoving = false;
    }
    else
    {
      isMoving = true;
    }

    if (cc.isGrounded && verticalVelocity < 0f)
      verticalVelocity = -1f;

    Quaternion targetRot;

    // Debug.Log("xVelocity: " + horizontalVelocity);

    if (isMoving)
    {
      targetRot =
        (dir == 1) ? Quaternion.Euler(180f, -90f, -90f) : Quaternion.Euler(0f, -90f, -90f);
    }
    else if (isAttacking)
    {
      targetRot = transform.localRotation;
    }
    else
    {
      targetRot = Quaternion.Euler(270f, -90f, -90f);
    }

    // smooth turn
    transform.localRotation = Quaternion.RotateTowards(
      transform.localRotation,
      targetRot,
      turnSpeed * Time.deltaTime
    );
    verticalVelocity += gravity * Time.deltaTime;
    Vector3 move = new Vector3(horizontalVelocity, verticalVelocity, 0f);

    var flags = cc.Move(move * Time.deltaTime);
    if ((flags & CollisionFlags.Sides) != 0 && !isAttacking)
    {
      dir *= -1;
      pause = 0.2f;
    }
  }

  void OnTriggerStay(Collider other)
  {
    var bound = other.GetComponent<PatrolBound>();
    if (!bound)
      return;

    dir = (bound.side == PatrolBound.Side.Left) ? 1 : -1;

    if (currentBound != bound)
    {
      currentBound = bound;
      pause = 1.5f;
    }
  }

  public override void TakeDamage(int damage)
  {
    hitPoints -= damage;
    Debug.Log("Skeleton hitpoints: " + hitPoints);
    if (hitPoints <= 0)
    {
      Debug.Log("Skeleton dead");
      Die();
    }
  }

  private void Die()
  {
    IEnumerator DelayedDisable()
    {
      yield return new WaitUntil(() => animator.GetCurrentAnimatorStateInfo(0).IsName("Death"));

      var state = animator.GetCurrentAnimatorStateInfo(0);
      Debug.Log("Skeleton death animation duration: " + state.length / state.speed);

      yield return new WaitForSeconds(state.length / state.speed);

      gameObject.SetActive(false);
    }
    isDying = true;
    animator.SetTrigger("death");
    StartCoroutine(DelayedDisable());
  }

  private float Attack()
  {
    isAttacking = true;
    animator.SetTrigger("attack");
    attackId++;

    // why does unity not allow to search for state instead of clip??
    // this will break if i change animation speed inside of state
    foreach (var clip in animator.runtimeAnimatorController.animationClips)
    {
      if (clip.name == "SkeletonAttack")
      {
        Debug.Log("Attack clip length: " + clip.length);
        return clip.length;
      }
    }

    Debug.LogError("clip not found");

    return 0f;
  }

  private bool TryAttack()
  {
    attackCooldown = Mathf.Max(attackCooldown - Time.deltaTime, 0f);

    if (attackCooldown == 0f)
    {
      isAttacking = false;
    }

    Vector3 vecToPlayer = player.position - transform.position;

    // Debug.Log(vecToPlayer.x);

    bool inRange = Mathf.Abs(vecToPlayer.x) <= attackRange;
    bool inFront = Mathf.Sign(vecToPlayer.x) == dir;
    bool sameHeight = Mathf.Abs(vecToPlayer.y) <= verticalTolerance;

    if (inRange && inFront && sameHeight && !isAttacking && attackCooldown <= 0f)
    {
      attackCooldown = Attack() + attackDelay;
      pause = attackCooldown;
      return true;
    }

    return false;
  }
}
