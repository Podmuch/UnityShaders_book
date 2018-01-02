using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace PDGames
{
    [ExecuteInEditMode]
    public class BSC_ImageEffect : MonoBehaviour
    {
        [SerializeField]
        private Shader curShader;
        [SerializeField]
        [Range(0.0f, 5.0f)]
        private float brightnessAmount = 1.0f;
        [SerializeField]
        [Range(0.0f, 5.0f)]
        private float saturationAmount = 1.0f;
        [SerializeField]
        [Range(0.0f, 5.0f)]
        private float contrastAmount = 1.0f;

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

        private void Start()
        {
            if (!SystemInfo.supportsImageEffects)
            {
                enabled = false;
            }
            else if (curShader != null && !curShader.isSupported)
            {
                enabled = false;
            }
        }

        private void OnRenderImage(RenderTexture sourceTexture, RenderTexture destTexture)
        {
            if (curShader != null)
            {
                material.SetFloat("_BrightnessAmount", brightnessAmount);
                material.SetFloat("_SatAmount", saturationAmount);
                material.SetFloat("_ConAmount", contrastAmount);

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