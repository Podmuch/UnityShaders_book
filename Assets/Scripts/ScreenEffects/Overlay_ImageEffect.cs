using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace PDGames
{
    [ExecuteInEditMode]
    public class Overlay_ImageEffect : MonoBehaviour
    {
        [SerializeField]
        private Shader curShader;
        [SerializeField]
        public Texture2D blendTexture;

        [SerializeField]
        [Range(0.0f, 1.0f)]
        private float blendOpacity = 1.0f;

        [SerializeField]
        private Material curMaterial;

        private Material material
        {
            get
            {
                if (curMaterial == null)
                {
                    curMaterial = new Material(curShader);
                    curMaterial.hideFlags = HideFlags.HideAndDontSave;
                }
                return curMaterial;
            }
        }

        private void OnRenderImage(RenderTexture sourceTexture, RenderTexture destTexture)
        {
            if (curShader != null)
            {
                material.SetTexture("_BlendTex", blendTexture);
                material.SetFloat("_Opacity", blendOpacity);

                Graphics.Blit(sourceTexture, destTexture, material);
            }
            else
            {
                Graphics.Blit(sourceTexture, destTexture);
            }
        }

        private void OnDisable()
        {
            if (curMaterial != null)
            {
                DestroyImmediate(curMaterial);
            }
        }
    }
}
