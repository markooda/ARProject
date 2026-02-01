using UnityEngine;

public class SkeletonHealthBarRotate : MonoBehaviour
{
  private Camera mainCamera;

  // Start is called once before the first execution of Update after the MonoBehaviour is created
  void Start()
  {
    mainCamera = Camera.main;
  }

  // Update is called once per frame
  void LateUpdate()
  {
    if (!mainCamera)
      return;

    Vector3 toCam = mainCamera.transform.position - transform.position;

    if (toCam.sqrMagnitude < 0.001f)
      return;

    Quaternion lookRotation = Quaternion.LookRotation(toCam.normalized);

    // tutifruti worldspace hack
    // ar target is placed on a wall, model is rotated by 0, 90, 90
    Vector3 euler = lookRotation.eulerAngles;
    euler.x = 0f;
    euler.y = euler.y + 90f;
    euler.z = mainCamera.transform.eulerAngles.z;

    transform.rotation = Quaternion.Euler(euler);

    // Debug.Log("Health bar rotation: " + transform.rotation);
  }
}
