using UnityEngine;

public class HealthPowerUp : PowerUp
{
  [Header("Heal Amount")]
  public int hitpoints = 25;

  protected override void Apply(PlayerGroundFollower player)
  {
    if (player.RestoreHealth(hitpoints))
      gameObject.SetActive(false);
  }
}
