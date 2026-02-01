using System.Collections.Generic;
using UnityEngine;

public class Cheats : MonoBehaviour
{
  [Header("GameObjects")]
  public GameObject tower;
  public GameObject skeleton;
  public GameObject player;

  private Dictionary<GameObject, Quaternion> rotations = new Dictionary<GameObject, Quaternion>();
  private Dictionary<GameObject, Vector3> positions = new Dictionary<GameObject, Vector3>();
  private Vector3 playerPosition;

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

    rotations.Add(skeleton, skeleton.transform.rotation);
    positions.Add(skeleton, skeleton.transform.localPosition);

    playerPosition = player.transform.position;
  }

  private void ResetTower()
  {
    tower.transform.rotation = rotations[tower];
  }

  private void ResetSkeleton()
  {
    Debug.Log($"Before reset: {skeleton.transform.position}");

    Debug.Log($"After controller reset: {skeleton.transform.position}");

    skeleton.transform.localPosition = positions[skeleton];
    skeleton.transform.rotation = rotations[skeleton];

    skeleton.GetComponent<SkeletonController>().Reset();
    Debug.Log($"After setting pose: {skeleton.transform.position}");
  }

  public void ResetGameObjects()
  {
    ResetTower();
    ResetSkeleton();
  }

  public void CenterPlayer()
  {
    Debug.Log("Centering player");
    player.transform.position = playerPosition;
  }
}
