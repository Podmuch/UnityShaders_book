using UnityEngine;

namespace PDGames
{
    public class ReplacedShader : MonoBehaviour
    {
        [SerializeField]
        private Shader shader;

        void Start()
        {
            GetComponent<Camera>().SetReplacementShader(shader, "RenderType");
        }
    }
}