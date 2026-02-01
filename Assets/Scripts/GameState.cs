using TMPro;
using UnityEngine;

public class GameState : MonoBehaviour
{
  [Header("Settings")]
  public GameObject gameWorld;
  public int maxLives = 3;
  private int lives;

  private GameObject enemies;
  private GameObject player;

  private Vector3 foregroundPos;
  private Vector3 backgroundNearPos;
  private Vector3 backgroundFarPos;
  private Vector3 backgroundVeryFarPos;

  [Header("UI")]
  public TextMeshProUGUI textUi;

  void Awake()
  {
    foregroundPos = gameWorld.transform.Find("Foreground").position;
    backgroundNearPos = gameWorld.transform.Find("BackgroundNear").position;
    backgroundFarPos = gameWorld.transform.Find("BackgroundFar").position;
    backgroundVeryFarPos = gameWorld.transform.Find("BackgroundVeryFar").position;

    enemies = gameWorld.transform.Find("Foreground/Enemies").gameObject;
    player = GameObject.FindGameObjectWithTag("Player");

    lives = maxLives;

    textUi.text = "Lives: " + lives;
  }

  // Update is called once per frame
  void Update() { }

  public void ResetGame()
  {
    gameWorld.transform.Find("Foreground").position = foregroundPos;
    gameWorld.transform.Find("BackgroundNear").position = backgroundNearPos;
    gameWorld.transform.Find("BackgroundFar").position = backgroundFarPos;
    gameWorld.transform.Find("BackgroundVeryFar").position = backgroundVeryFarPos;

    var playerController = player.GetComponent<PlayerGroundFollower>();
    playerController.Reset();

    lives--;
    textUi.text = "Lives: " + lives;

    if (lives < 0)
    {
      var controllers = enemies.GetComponentsInChildren<EnemyController>(true);
      foreach (var controller in controllers)
      {
        controller.Reset();
      }

      lives = maxLives;
    }
  }
}
