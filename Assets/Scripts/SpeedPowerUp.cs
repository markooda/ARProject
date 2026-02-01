using UnityEngine;

public class SpeedPowerUp : PowerUp
{
  [Header("Speed Settings")]
  public float speed = 10f;
  public int duration = 25;

  protected override void Apply(PlayerGroundFollower player)
  {
    player.IncreaseMovementSpeed(speed, duration);
    gameObject.SetActive(false);
  }
}
