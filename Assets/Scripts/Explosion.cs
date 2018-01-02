using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace PDGames
{
    [RequireComponent(typeof(MeshRenderer))]
    public class Explosion : MonoBehaviour
    {
        private MeshRenderer meshRenderer;

        private float privTime;
        private MaterialPropertyBlock block;

        void Start()
        {
            meshRenderer = GetComponent<MeshRenderer>();
            float period = meshRenderer.sharedMaterial.GetFloat("_Period") / 3;
            privTime = 0;
            block = new MaterialPropertyBlock();
            meshRenderer.GetPropertyBlock(block);
            block.SetFloat("_CurTime", privTime);
            meshRenderer.SetPropertyBlock(block);
            Destroy(gameObject, period);
        }

        void Update()
        {
            privTime += Time.deltaTime * 3;
            block.SetFloat("_CurTime", privTime);
            meshRenderer.SetPropertyBlock(block);
        }
    }
}