using System.Collections.Generic;
using UnityEngine;

public class PlayerWeaponHitbox : MonoBehaviour
{
  private PlayerGroundFollower player;
  private Dictionary<EnemyController, int> lastHit = new();

  void Awake()
  {
    player = GetComponentInParent<PlayerGroundFollower>();
  }

  void OnTriggerEnter(Collider other)
  {
    if (!player.isAttacking)
      return;

    if (!other.CompareTag("Enemy"))
      return;

    var enemy = other.GetComponentInParent<EnemyController>();
    if (enemy == null)
      return;

    int id = player.attackId;

    if (lastHit.TryGetValue(enemy, out int prev) && prev == id)
      return;

    lastHit[enemy] = id;

    enemy.TakeDamage(player.damage);
  }
}
