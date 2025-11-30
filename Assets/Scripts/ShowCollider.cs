using UnityEngine;

[ExecuteInEditMode]
public class ShowCollider : MonoBehaviour
{
  void OnDrawGizmos()
  {
    Collider col = GetComponent<Collider>();
    if (col == null)
      return;

    Gizmos.color = Color.yellow;

    if (col is BoxCollider box)
    {
      Gizmos.matrix = transform.localToWorldMatrix;
      Gizmos.DrawWireCube(box.center, box.size);
    }
    else if (col is SphereCollider sphere)
    {
      Gizmos.matrix = transform.localToWorldMatrix;
      Gizmos.DrawWireSphere(sphere.center, sphere.radius);
    }
    else if (col is CapsuleCollider capsule)
    {
      Gizmos.matrix = transform.localToWorldMatrix;
      // Simple approximation using two spheres
      float height = Mathf.Max(0, capsule.height - 2 * capsule.radius);
      Vector3 top = capsule.center + Vector3.up * height / 2f;
      Vector3 bottom = capsule.center - Vector3.up * height / 2f;
      Gizmos.DrawWireSphere(top, capsule.radius);
      Gizmos.DrawWireSphere(bottom, capsule.radius);
    }
  }
}
