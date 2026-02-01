using UnityEngine;

public abstract class EnemyController : MonoBehaviour
{
  [Header("Health")]
  [SerializeField]
  protected int hitPoints = 100;

  public int HitPoints => hitPoints;

  public abstract void TakeDamage(int damage);
  public abstract void Reset();
}
