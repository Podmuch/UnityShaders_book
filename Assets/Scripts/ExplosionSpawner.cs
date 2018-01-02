using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace PDGames
{
    public class ExplosionSpawner : MonoBehaviour
    {
        [SerializeField]
        private Transform ExplosionPrefab;

        [SerializeField]
        private float SpawnTime;
        [SerializeField]
        private float Range;

        private float timer = 0;

        void Update()
        {
            timer += Time.deltaTime;
            if (timer > SpawnTime)
            {
                timer -= SpawnTime;
                Transform newExplosion = Instantiate<Transform>(ExplosionPrefab, transform);
                newExplosion.localScale = Vector3.one;
                newExplosion.localPosition = new Vector3(Random.Range(-Range * 0.5f, Range * 0.5f), 0, Random.Range(-Range * 0.5f, Range * 0.5f));
            }
        }
    }
}