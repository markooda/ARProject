using UnityEngine;
using UnityEngine.UI;

public class MageHealthBarUI : MonoBehaviour
{
  private SkeletonController skeleton;
  private Image fillImage;

  [Header("Health Settings")]
  public float maxHealth = 100f;

  [Header("Smoothing")]
  public float fillSpeed = 1.7f;

  private float currentFill;

  void Awake()
  {
    skeleton = GetComponentInParent<SkeletonController>();

    Transform fill = transform.Find("Background/Fill");
    // if (!fill)
    // {
    //   fill = transform.GetComponentInChildren<Transform>(true);
    // }

    fillImage = fill.GetComponent<Image>();

    currentFill = Mathf.Clamp01(skeleton.HitPoints / maxHealth);
    fillImage.fillAmount = currentFill;
  }

  // Update is called once per frame
  void Update()
  {
    if (!skeleton || !fillImage)
      return;

    float targetFill = Mathf.Clamp01(skeleton.HitPoints / maxHealth);

    currentFill = Mathf.MoveTowards(currentFill, targetFill, fillSpeed * Time.deltaTime);

    fillImage.fillAmount = currentFill;
  }
}
