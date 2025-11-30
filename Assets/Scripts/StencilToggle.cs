using UnityEngine;

public class StencilMaskSwitcher : MonoBehaviour
{
  public GameObject editorQuad; // Full-world quad
  public GameObject playQuad; // Book cutout quad

  void Awake()
  {
    bool isPlaying = Application.isPlaying;
    editorQuad.SetActive(!isPlaying);
    playQuad.SetActive(isPlaying);
  }
}
