using UnityEngine;

public class DamagePowerUp : PowerUp
{
  [Header("Damage Amount")]
  public int damage = 25;

  protected override void Apply(PlayerGroundFollower player)
  {
    player.IncreaseDamage(damage);
    gameObject.SetActive(false);
  }
}
