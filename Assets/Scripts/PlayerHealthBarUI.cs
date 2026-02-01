using UnityEngine;
using UnityEngine.UI;

public class PlayerHealthBarUI : MonoBehaviour
{
  [Header("Player Controller")]
  public PlayerGroundFollower player;
  private Image fillImage;

  [Header("Health Settings")]
  public float maxHealth = 100f;

  [Header("Smoothing")]
  public float fillSpeed = 1.7f;

  private float currentFill;

  void Awake()
  {
    if (!player)
    {
      player = GameObject.FindGameObjectWithTag("Player").GetComponent<PlayerGroundFollower>();
    }
    Transform fill = transform.Find("Background/Fill");
    fillImage = fill.GetComponent<Image>();

    currentFill = Mathf.Clamp01(player.hitPoints / maxHealth);
    fillImage.fillAmount = currentFill;
  }

  // Update is called once per frame
  void Update()
  {
    if (!player || !fillImage)
      return;

    float targetFill = Mathf.Clamp01(player.hitPoints / maxHealth);

    currentFill = Mathf.MoveTowards(currentFill, targetFill, fillSpeed * Time.deltaTime);

    fillImage.fillAmount = currentFill;
  }
}
