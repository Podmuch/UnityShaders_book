Shader "Hidden/PDGames/SceneDepth_Effect"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_DepthPower("Depth Power", Range(0.1, 5.0)) = 1
	}
	SubShader
	{
		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma fragmentoption ARB_precision_hint_fastest
			
			#include "UnityCG.cginc"

			uniform sampler2D _MainTex;
			uniform fixed _DepthPower;
			sampler2D _CameraDepthTexture;

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
				o.uv = v.uv;
				o.uv.y = 1 - o.uv.y;
				return o;
			}

			fixed4 frag (v2f i) : SV_Target
			{
				float d = UNITY_SAMPLE_DEPTH(tex2D(_CameraDepthTexture, i.uv.xy));
				d = pow(Linear01Depth(d), _DepthPower);
				return d;
			}
			ENDCG
		}
	}
}
