using UnityEngine;

public abstract class PowerUp : MonoBehaviour
{
  protected virtual void Update()
  {
    transform.Rotate(0f, 45f * Time.deltaTime, 0f, Space.World);
  }

  public virtual void Reset()
  {
    gameObject.SetActive(true);
  }

  public virtual void OnTriggerEnter(Collider other)
  {
    if (other.gameObject.tag == "Player")
    {
      var player = other.gameObject.GetComponent<PlayerGroundFollower>();
      Apply(player);
    }
  }

  protected abstract void Apply(PlayerGroundFollower player);
}
