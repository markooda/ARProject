using UnityEngine;

public class TowerPlatform : MonoBehaviour
{
  public float GetLevelZ(Transform foreground, Transform baseGround)
  {
    float stepZ = foreground.InverseTransformPoint(transform.position).z;
    float groundZ = foreground.InverseTransformPoint(baseGround.position).z;

    return stepZ - groundZ;
  }
}
