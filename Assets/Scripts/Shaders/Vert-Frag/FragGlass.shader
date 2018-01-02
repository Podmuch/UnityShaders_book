Shader "PDGames/FragGlass"
{
	Properties
	{
		_MainTex("Base (RGB) Trans (A)", 2D) = "white" {}
		_BumpMap("Noise text", 2D) = "bump" {}
		_Magnitude("Magnitude", Range(0,1)) = 0.05
		_Colour("Color", Color) = (1,1,1,1)
	}
	SubShader
	{
		Tags{ "RenderType" = "Transparent" "IgnoreProjector" = "True" "Queue" = "Transparent" }

		LOD 100
		GrabPass{}
		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			sampler2D _GrabTexture;
			sampler2D _MainTex;
			sampler2D _BumpMap;
			float _Magnitude;
			half4 _Colour;

			struct vertInput
			{
				float4 vertex : POSITION;
				float2 texcoord : TEXCOORD0;
			};

			struct vertOutput
			{
				float4 vertex : POSITION;
				float2 texcoord : TEXCOORD0;
				float4 uvgrab : TEXCOORD1;
			};

			vertOutput vert(vertInput v)
			{
				vertOutput o;
				o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
				o.uvgrab = ComputeGrabScreenPos(o.vertex);
				o.texcoord = v.texcoord;
				return o;
			}

			half4 frag(vertOutput v2f) : COLOR
			{
				half4 mainColour = tex2D(_MainTex, v2f.texcoord);
				half4 bump = tex2D(_BumpMap, v2f.texcoord);
				half2 distortion = UnpackNormal(bump).rg;
				v2f.uvgrab.xy += distortion * _Magnitude;
				fixed4 col = tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(v2f.uvgrab));
				return col * mainColour * _Colour;
			}
			ENDCG
		}
	}
}
