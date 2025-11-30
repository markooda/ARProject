using System.Collections.Generic;
using UnityEngine;

public class Cheats : MonoBehaviour
{
  [Header("GameObjects")]
  public GameObject tower;

  private Dictionary<GameObject, Quaternion> rotations = new Dictionary<GameObject, Quaternion>();
  private Dictionary<GameObject, Vector3> positions = new Dictionary<GameObject, Vector3>();

  // singleton helper class
  public static Cheats Instance { get; private set; }

  void Awake()
  {
    if (Instance != null && Instance != this)
    {
      Destroy(gameObject);
      return;
    }

    Instance = this;
    DontDestroyOnLoad(gameObject);

    // set initial rotations
    rotations.Add(tower, tower.transform.rotation);
    positions.Add(tower, tower.transform.position);
  }

  public void ResetTower()
  {
    tower.transform.rotation = rotations[tower];
  }
}
