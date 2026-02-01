using UnityEngine;
using Vuforia;

public class VuforiaListener : MonoBehaviour
{
  public GameObject gameworld;
  public Canvas UI;

  private ObserverBehaviour observer;

  void Awake()
  {
    gameworld.SetActive(false);
    UI.enabled = false;
    observer = GetComponent<ObserverBehaviour>();
  }

  void OnEnable()
  {
    observer.OnTargetStatusChanged += OnTargetStatusChanged;
  }

  void OnDisable()
  {
    observer.OnTargetStatusChanged -= OnTargetStatusChanged;
  }

  void OnTargetStatusChanged(ObserverBehaviour behaviour, TargetStatus targetStatus)
  {
    Debug.Log($"Target status: {targetStatus.Status} -- {targetStatus.StatusInfo}");

    if (IsPoseValid(targetStatus))
    {
      OnPoseAcquired();
    }
    else
    {
      OnPoseLost();
    }
  }

  bool IsPoseValid(TargetStatus status)
  {
    return status.Status == Status.TRACKED || status.Status == Status.EXTENDED_TRACKED;
  }

  void OnPoseAcquired()
  {
    Debug.Log("AR pose acquired");

    // Enable physics / enemies / world here
    gameworld.SetActive(true);
    UI.enabled = true;
  }

  void OnPoseLost()
  {
    Debug.Log("AR pose lost");

    // Optional: freeze physics or hide world
    gameworld.SetActive(false);
    UI.enabled = false;
  }
}
