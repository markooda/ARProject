using UnityEngine;

[ExecuteInEditMode]
public class PostprocessingScript : MonoBehaviour
{
  public Material postMat; // shader material

  void OnRenderImage(RenderTexture src, RenderTexture dest)
  {
    Graphics.Blit(src, dest, postMat);
  }
}
