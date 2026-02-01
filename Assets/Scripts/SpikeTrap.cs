using UnityEngine;

public class SpikeTrap : MonoBehaviour
{
  [Header("Spike Damage")]
  public int damage = 10;
  public float damageInterval = 1f;

  private float nextDamageTick = 0f;
  private PlayerGroundFollower player;

  // Start is called once before the first execution of Update after the MonoBehaviour is created
  void Start() { }

  // Update is called once per frame
  void Update()
  {
    if (player)
      nextDamageTick -= Time.deltaTime;
  }

  void OnTriggerEnter(Collider other)
  {
    if (other.gameObject.tag == "Player")
    {
      player = other.GetComponent<PlayerGroundFollower>();
    }
  }

  void OnTriggerStay(Collider other)
  {
    if (other.gameObject.tag == "Player")
    {
      if (nextDamageTick <= 0f)
      {
        player.TakeDamage(damage);
        nextDamageTick = damageInterval;
      }
    }
  }
}
