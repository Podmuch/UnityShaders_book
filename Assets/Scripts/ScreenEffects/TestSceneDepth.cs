using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace PDGames
{
    [ExecuteInEditMode]
    public class TestSceneDepth : MonoBehaviour
    {
        [SerializeField]
        private Shader curShader;
        [SerializeField]
        [Range(0.1f, 5.0f)]
        private float depthPower = 1.0f;
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
            else
            {
                Camera.main.depthTextureMode = DepthTextureMode.Depth;
            }
        }

        private void OnRenderImage(RenderTexture sourceTexture, RenderTexture destTexture)
        {
            if (curShader != null)
            {
                material.SetFloat("_DepthPower", depthPower);
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