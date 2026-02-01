using UnityEngine;

public class FrostboltProjectile : MonoBehaviour
{
  public float speed = 12f;
  public float turnSpeed = 8f;
  public int damage = 10;
  public float lifetime = 5f;

  private Transform target;

  public void Initialize(Transform target)
  {
    this.target = target;
    Destroy(gameObject, lifetime);
  }

  void Update()
  {
    if (target == null)
    {
      Destroy(gameObject);
      return;
    }

    Vector3 direction = (target.position - transform.position).normalized;

    Quaternion targetRotation = Quaternion.LookRotation(direction);
    transform.rotation = Quaternion.Slerp(
      transform.rotation,
      targetRotation,
      turnSpeed * Time.deltaTime
    );

    transform.position += transform.forward * speed * Time.deltaTime;
  }

  void OnTriggerEnter(Collider other)
  {
    if (!other.CompareTag("Player"))
    {
      if (other.gameObject.layer == LayerMask.NameToLayer("Obstacles"))
        Destroy(gameObject);

      return;
    }

    var enemy = other.GetComponentInParent<PlayerGroundFollower>();
    if (enemy == null)
      return;

    if (enemy.isBlocking)
    {
      Vector3 toEnemy = (transform.position - enemy.transform.position).normalized;
      Vector3 playerForward = enemy.transform.right;

      bool isFacingEnemy = Vector3.Dot(playerForward, toEnemy) > 0f;

      if (isFacingEnemy)
      {
        Debug.Log("Player blocked");
        Destroy(gameObject);
        return;
      }
    }

    Debug.Log("Player hit by frostbolt");
    enemy.TakeDamage(damage);
    Destroy(gameObject);
  }
}
