using System.Collections;
using UnityEngine;

public class MageController : EnemyController
{
  private Transform player;

  // private Rigidbody rb;
  [Header("Animation")]
  private Animator animator;
  public float turnSpeed = 540f;

  private CharacterController cc;

  [Header("Gravity")]
  public float gravity = -20f;
  private float verticalVelocity = 0f;

  [Header("Combat")]
  public float attackRange = 10f;
  public float attackDelay = 0.5f;
  public FrostboltProjectile frostboltProjectile;
  public Transform castPoint;

  private Transform projectilesRoot;

  public bool isAttacking { get; private set; } = false;
  private bool isDying;
  public int attackId { get; private set; } = 0;

  private Vector3 startPos;

  public override void Reset()
  {
    gameObject.SetActive(true);
    transform.position = startPos;
    hitPoints = 50;
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
    isDying = false;
    player = GameObject.FindGameObjectWithTag("Player").transform;
    projectilesRoot = GameObject.FindGameObjectWithTag("Projectiles").transform;
  }

  // Update is called once per frame
  void Update()
  {
    if (isDying)
      return;

    bool attacked = TryAttack();

    if (cc.isGrounded && verticalVelocity < 0f)
      verticalVelocity = -1f;

    float dx = player.transform.position.x - transform.position.x;
    float targetXRot = (dx >= 0f) ? 0f : 180f;

    Quaternion targetRot = Quaternion.Euler(targetXRot, 90f, 90f);
    // smooth turn
    transform.localRotation = Quaternion.RotateTowards(
      transform.localRotation,
      targetRot,
      turnSpeed * Time.deltaTime
    );
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

  private IEnumerator Attack()
  {
    animator.SetTrigger("casting");
    isAttacking = true;

    yield return new WaitUntil(() => animator.GetCurrentAnimatorStateInfo(0).IsName("Casting"));

    var state = animator.GetCurrentAnimatorStateInfo(0);
    float duration = state.length / state.speed;

    yield return new WaitForSeconds(duration * 0.35f);

    attackId++;
    var bolt = Instantiate(
      frostboltProjectile,
      castPoint.position,
      castPoint.rotation,
      projectilesRoot
    );
    bolt.Initialize(player);

    yield return new WaitForSeconds(duration * 0.65f + attackDelay);

    isAttacking = false;
  }

  // private float Attack()
  // {
  //   isAttacking = true;
  //   animator.SetTrigger("casting");
  //   attackId++;
  //
  //   // why does unity not allow to search for state instead of clip??
  //   // this will break if i change animation speed inside of state
  //   foreach (var clip in animator.runtimeAnimatorController.animationClips)
  //   {
  //     if (clip.name == "MageCasting")
  //     {
  //       Debug.Log("Attack clip length: " + clip.length);
  //       return clip.length;
  //     }
  //   }
  //
  //   Debug.LogError("clip not found");
  //
  //   return 0f;
  // }

  private bool TryAttack()
  {
    Vector3 vecToPlayer = player.position - transform.position;

    // Debug.Log(vecToPlayer.x);

    bool inRange = Mathf.Abs(vecToPlayer.x) <= attackRange;

    if (inRange && !isAttacking)
    {
      StartCoroutine(Attack());
      return true;
    }

    return false;
  }
}
