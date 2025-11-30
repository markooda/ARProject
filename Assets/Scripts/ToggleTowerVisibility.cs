using System.Collections.Generic;
using UnityEngine;

[ExecuteAlways]
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

  // Option: ignore trigger colliders so we don't accidentally toggle the zones themselves
  public bool ignoreTriggers = true;

  // Buffer so tiny bounding overlaps don't flip constantly
  public float boundsInflation = 0f;

  void Update()
  {
    if (colliderBack == null || colliderCenter == null || colliderFront == null)
      return;

    // Get every collider in this tower (any depth)
    Collider[] all = GetComponentsInChildren<Collider>(true);

    // We'll record which roots we've already set this frame to avoid duplicates
    var processed = new HashSet<GameObject>();

    foreach (var col in all)
    {
      if (col == null)
        continue;
      if (ignoreTriggers && col.isTrigger)
        continue; // skip trigger markers

      // don't toggle the actual zone colliders if they are parenting inside this structure
      if (col == colliderBack || col == colliderCenter || col == colliderFront)
        continue;

      GameObject target = col.gameObject;

      // Avoid processing same GameObject twice (multiple colliders etc.)
      if (processed.Contains(target))
        continue;

      // Expand bounds optionally to avoid micro overlaps
      Bounds b = col.bounds;
      if (boundsInflation != 0f)
        b.Expand(boundsInflation);

      bool inFront = BoundsIntersects(b, colliderFront.bounds);
      bool inBack = BoundsIntersects(b, colliderBack.bounds);
      bool inCenter = BoundsIntersects(b, colliderCenter.bounds);

      if (inFront || inBack)
      {
        // Set this particular object's subtree to Hidden (but Tower-tagged objects use Ground)
        SetLayerRecursive(target.transform, LayerMask.NameToLayer(hiddenLayer));
      }
      else if (inCenter)
      {
        // If this object (or an ancestor) has tag "Tower", put it on Ground layer,
        // otherwise Default. You can change to check only this object by removing HasTagInAncestors.
        if (HasTagInAncestors(target.transform, "Tower"))
          SetLayerRecursive(target.transform, LayerMask.NameToLayer(groundLayer));
        else
          SetLayerRecursive(target.transform, LayerMask.NameToLayer(defaultLayer));
      }
      else
      {
        // Not in any zone — optionally treat as hidden by default,
        // or you can leave as is. Here we leave unchanged.
      }

      processed.Add(target);
    }
  }

  // small helper to avoid floating point bounds weirdness
  bool BoundsIntersects(Bounds a, Bounds b)
  {
    return a.Intersects(b);
  }

  // Recursively set layer for obj and all its children
  void SetLayerRecursive(Transform obj, int layer)
  {
    obj.gameObject.layer = layer;
    // If object has multiple renderers or nested children we want them to be on this layer too
    for (int i = 0; i < obj.childCount; i++)
    {
      SetLayerRecursive(obj.GetChild(i), layer);
    }
  }

  // Walk upward and see if any ancestor (including self) has the given tag.
  // This is helpful if your "Tower" tag is on a group and you want children to inherit that classification.
  bool HasTagInAncestors(Transform t, string tag)
  {
    var cur = t;
    while (cur != null && cur != this.transform.parent) // stop if you want to prevent leaving the prefab root
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
