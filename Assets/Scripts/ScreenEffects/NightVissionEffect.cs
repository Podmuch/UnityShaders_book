using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace PDGames
{
    [ExecuteInEditMode]
    public class NightVissionEffect : MonoBehaviour
    {
        [SerializeField]
        private Shader curShader;

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


        [Header("NightVision")]
        [SerializeField]
        private Color nightVisionColor = Color.green;
        [SerializeField]
        [Range(0.0f, 4.0f)]
        private float contrast = 2.0f;
        [SerializeField]
        [Range(0.0f, 2.0f)]
        private float brightness = 1.0f;

        [Header("Distortion")]
        [SerializeField]
        [Range(-1f, 1f)]
        private float distortion = 0;
        [SerializeField]
        [Range(0f, 3f)]
        private float scale = 1;

        [Header("Vignette")]
        [SerializeField]
        private Texture2D vignetteTexture;
        [SerializeField]
        [Range(0.0f, 1.0f)]
        private float vignetteAmount = 1.0f;

        [Header("ScanLines")]
        [SerializeField]
        private Texture2D scanLineTexture;
        [SerializeField]
        private float scanLineTileAmount = 4.0f;

        [Header("Noise")]
        [SerializeField]
        private Texture2D noiseTexture;
        [SerializeField]
        private float noiseXSpeed = 100.0f;
        [SerializeField]
        private float noiseYSpeed = 100.0f;

        private float randomValue;

        void Update()
        {
            randomValue = Random.Range(-1f, 1f);
        }

        private void OnRenderImage(RenderTexture sourceTexture, RenderTexture destTexture)
        {
            if (curShader != null)
            {
                //NightVision
                material.SetColor("_NightVisionColor", nightVisionColor);
                material.SetFloat("_Contrast", contrast);
                material.SetFloat("_Brightness", brightness);
                material.SetFloat("_distortion", distortion);
                material.SetFloat("_scale", scale);

                //Vignette
                if (vignetteTexture)
                {
                    material.SetTexture("_VignetteTex", vignetteTexture);
                    material.SetFloat("_VignetteAmount", vignetteAmount);
                }
                //Scanlines
                if (scanLineTexture)
                {
                    material.SetTexture("_ScanLineTex", scanLineTexture);
                    material.SetFloat("_ScanLineTileAmount", scanLineTileAmount);
                }
                //Noise
                if (noiseTexture)
                {
                    material.SetTexture("_NoiseTex", noiseTexture);
                    material.SetFloat("_NoiseXSpeed", noiseXSpeed);
                    material.SetFloat("_NoiseYSpeed", noiseYSpeed);
                }

                material.SetFloat("_RandomValue", randomValue);

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