using System.Collections.Generic;
using UnityEngine;

// TODO: Currently this occludes objects by toggling the layer to hidden.
// The AR camera does not render the hidden layer. In the future I might wanna add a
// way to not completely occlude objects but to make them transparent instead

// [ExecuteAlways] // for debugging in edit mode
public class ToggleTowerVisibility : MonoBehaviour
{
  [Header("Zone triggers (assign colliders or trigger gameobjects)")]
  public Collider colliderBack;
  public Collider colliderCenter;
  public Collider colliderFront;

  [Header("Layer names")]
  public string hiddenLayer = "Hidden";
  public string defaultLayer = "Default";
  public string groundLayer = "Ground";

  public bool ignoreTriggers = true;
  public float boundsInflation = 0f;

  void Update()
  {
    if (colliderBack == null || colliderCenter == null || colliderFront == null)
      return;

    Collider[] all = GetComponentsInChildren<Collider>(true);

    var processed = new HashSet<GameObject>();

    foreach (var col in all)
    {
      if (col == null)
        continue;
      if (ignoreTriggers && col.isTrigger)
        continue;

      if (col == colliderBack || col == colliderCenter || col == colliderFront)
        continue;

      GameObject target = col.gameObject;

      if (processed.Contains(target))
        continue;

      Bounds b = col.bounds;
      if (boundsInflation != 0f)
        b.Expand(boundsInflation);

      bool inFront = BoundsIntersects(b, colliderFront.bounds);
      bool inBack = BoundsIntersects(b, colliderBack.bounds);
      bool inCenter = BoundsIntersects(b, colliderCenter.bounds);

      if (inFront || inBack)
      {
        SetLayerRecursive(target.transform, LayerMask.NameToLayer(hiddenLayer));
      }
      else if (inCenter)
      {
        if (
          (
            HasTagInAncestors(target.transform, "Tower")
            || HasTagInAncestors(target.transform, "TowerRock")
          ) && !target.transform.CompareTag("TowerIgnore")
        )
          SetLayerRecursive(target.transform, LayerMask.NameToLayer(groundLayer));
        else
          SetLayerRecursive(target.transform, LayerMask.NameToLayer(defaultLayer));
      }
      else { }

      processed.Add(target);
    }
  }

  bool BoundsIntersects(Bounds a, Bounds b)
  {
    return a.Intersects(b);
  }

  void SetLayerRecursive(Transform obj, int layer)
  {
    obj.gameObject.layer = layer;
    for (int i = 0; i < obj.childCount; i++)
    {
      SetLayerRecursive(obj.GetChild(i), layer);
    }
  }

  bool HasTagInAncestors(Transform t, string tag)
  {
    var cur = t;
    while (cur != null && cur != this.transform.parent)
    {
      if (cur.CompareTag(tag))
        return true;
      if (cur.parent == null)
        break;
      cur = cur.parent;
      if (cur == this.transform.parent)
        break;
    }
    return false;
  }
}
