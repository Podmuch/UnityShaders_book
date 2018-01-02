Shader "PDGames/FragWater"
{
	Properties
	{
		_MainTex("Base (RGB) Trans (A)", 2D) = "white" {}
		_NoiseTex("Noise text", 2D) = "white" {}
		_Magnitude("Magnitude", Range(0,1)) = 0.05
		_Colour("Color", Color) = (1,1,1,1)
		_Period("Period", Range(0,50)) = 1
		_Scale("Scale", Range(0,10)) = 1
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
			sampler2D _NoiseTex;

			half4 _Colour;
			float _Period;
			float _Magnitude;
			float _Scale;

			struct vertInput
			{
				float4 vertex : POSITION;
				float2 texcoord : TEXCOORD0;
			};

			struct vertOutput
			{
				float4 vertex : POSITION;
				float2 texcoord : TEXCOORD0;
				float4 worldPos : TEXCOORD1;
				float4 uvgrab : TEXCOORD2;
			};

			vertOutput vert(vertInput v)
			{
				vertOutput o;
				o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
				o.uvgrab = ComputeGrabScreenPos(o.vertex);
				o.worldPos = mul(_Object2World, v.vertex);
				o.texcoord = v.texcoord;
				return o;
			}

			half4 frag(vertOutput v2f) : COLOR
			{
				fixed4 mainColour = tex2D(_MainTex, v2f.texcoord.xy);
				float sinT = sin(_Time.w / _Period);
				float2 distortion = float2(tex2D(_NoiseTex, v2f.worldPos.xy / _Scale + float2(sinT, 0)).r - 0.5,
										   tex2D(_NoiseTex, v2f.worldPos.xy / _Scale + float2(0, sinT)).r - 0.5);
				v2f.uvgrab.xy += distortion * _Magnitude;
				fixed4 col = tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(v2f.uvgrab));
				return col * mainColour * _Colour;
			}
			ENDCG
		}
	}
}
