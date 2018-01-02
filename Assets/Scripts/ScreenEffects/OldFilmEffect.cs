using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace PDGames
{
    [ExecuteInEditMode]
    public class OldFilmEffect : MonoBehaviour
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


        [Space]
        [SerializeField]
        [Range(0.0f, 1.5f)]
        private float oldFilmEffectAmount = 1.0f;

        [Header("Sepia")]
        [SerializeField]
        private Color sepiaColor = Color.white;
        [SerializeField]
        private float contrast = 0;

        [Header("Vignette")]
        [SerializeField]
        private Texture2D vignetteTexture;
        [SerializeField]
        [Range(0.0f, 1.0f)]
        private float vignetteAmount = 1.0f;

        [Header("Scratches")]
        [SerializeField]
        private Texture2D scratchesTexture;
        [SerializeField]
        private float scratchesYSpeed = 10.0f;
        [SerializeField]
        private float scratchesXSpeed = 10.0f;

        [Header("Dust")]
        [SerializeField]
        private Texture2D dustTexture;
        [SerializeField]
        private float dustYSpeed = 10.0f;
        [SerializeField]
        private float dustXSpeed = 10.0f;

        private float randomValue;

        void Update()
        {
            randomValue = Random.Range(-1f, 1f);
        }

        private void OnRenderImage(RenderTexture sourceTexture, RenderTexture destTexture)
        {
            if (curShader != null)
            {
                material.SetFloat("_EffectAmount", oldFilmEffectAmount);

                //Sepia
                material.SetColor("_SepiaColor", sepiaColor);
                material.SetFloat("_Contrast", contrast);

                //Vignette
                if (vignetteTexture)
                {
                    material.SetTexture("_VignetteTex", vignetteTexture);
                }
                material.SetFloat("_VignetteAmount", vignetteAmount);
                //Scratches
                if(scratchesTexture)
                {
                    material.SetTexture("_ScratchesTex", scratchesTexture);
                    material.SetFloat("_ScratchesYSpeed",  scratchesYSpeed);
                    material.SetFloat("_ScratchesXSpeed", scratchesXSpeed);
                }
                //Dust
                if (dustTexture)
                {
                    material.SetTexture("_DustTex", dustTexture);
                    material.SetFloat("_dustYSpeed", dustYSpeed);
                    material.SetFloat("_dustXSpeed", dustXSpeed);
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