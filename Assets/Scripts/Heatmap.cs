using UnityEngine;
using System;
using System.Collections.Generic;

namespace PDGames
{
    [RequireComponent(typeof(MeshRenderer))]
    public class Heatmap : MonoBehaviour
    {
        [Serializable]
        private class HeatmapData
        {
            public Vector2 position;
            public float radius;
            public float intensity;
        }

        [SerializeField] private List<HeatmapData> Data;

        private MeshRenderer meshRenderer;

        private void Start()
        {
            meshRenderer = GetComponent<MeshRenderer>();
            Material material = meshRenderer.sharedMaterial;
            material.SetInt("_Points_Length", Data.Count);
            List<Vector4> positions = new List<Vector4>();
            List<Vector4> properties = new List<Vector4>();
            for (int i = 0; i < Data.Count; i++)
            {
                positions.Add(Data[i].position);
                properties.Add(new Vector2(Data[i].radius, Data[i].intensity));
            }
            material.SetVectorArray("_Points", positions);
            material.SetVectorArray("_Properties", properties);
        }
    }
}