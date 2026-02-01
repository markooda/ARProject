using UnityEngine;
using UnityEngine.UI;

public class EnemyHealthBarUI : MonoBehaviour
{
  private EnemyController enemy;
  private Image fillImage;

  // [Header("Health Settings")]
  // public float maxHealth = 100f;

  private float maxHealth;
  private GameObject player;

  [Header("Smoothing")]
  public float fillSpeed = 1.7f;

  [Header("Render distance")]
  public float renderDistance = 3.5f;

  private float currentFill;

  void Awake()
  {
    enemy = GetComponentInParent<EnemyController>();
    maxHealth = enemy.HitPoints;

    Transform fill = transform.Find("Background/Fill");
    // if (!fill)
    // {
    //   fill = transform.GetComponentInChildren<Transform>(true);
    // }

    fillImage = fill.GetComponent<Image>();

    currentFill = Mathf.Clamp01(enemy.HitPoints / maxHealth);
    fillImage.fillAmount = currentFill;

    player = GameObject.FindGameObjectWithTag("Player");
  }

  // Update is called once per frame
  void Update()
  {
    if (!enemy || !fillImage)
      return;

    Vector3 playerPos = player.transform.position;

    float dist = Vector3.Distance(transform.position, playerPos);

    // Debug.Log("dist: " + dist);
    if (dist > renderDistance)
    {
      gameObject.layer = LayerMask.NameToLayer("Hidden");
    }
    else
    {
      gameObject.layer = LayerMask.NameToLayer("Default");
    }

    float targetFill = Mathf.Clamp01(enemy.HitPoints / maxHealth);

    currentFill = Mathf.MoveTowards(currentFill, targetFill, fillSpeed * Time.deltaTime);

    fillImage.fillAmount = currentFill;
  }
}
