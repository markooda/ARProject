using System.Collections.Generic;
using UnityEngine;

public class EnemyWeaponHitbox : MonoBehaviour
{
  private SkeletonController skeleton;
  private Dictionary<PlayerGroundFollower, int> lastHit = new();

  void Awake()
  {
    skeleton = GetComponentInParent<SkeletonController>();
  }

  void OnTriggerEnter(Collider other)
  {
    if (!skeleton.isAttacking)
      return;

    if (!other.CompareTag("Player"))
      return;

    var enemy = other.GetComponentInParent<PlayerGroundFollower>();
    if (enemy == null)
      return;

    int id = skeleton.attackId;

    if (lastHit.TryGetValue(enemy, out int prev) && prev == id)
      return;

    lastHit[enemy] = id;

    if (enemy.isBlocking)
    {
      Vector3 toEnemy = (skeleton.transform.position - enemy.transform.position).normalized;
      Vector3 playerForward = enemy.transform.right;

      bool isFacingEnemy = Vector3.Dot(playerForward, toEnemy) > 0f;

      if (isFacingEnemy)
      {
        Debug.Log("Player blocked");
        return;
      }
    }

    Debug.Log("Player attacked");
    enemy.TakeDamage(10);
  }
}
