Shader "Hidden/PDGames/BSC_ImageEffect"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_BrightnessAmount("Brightness Amount", Range(0.0, 1.0)) = 1.0
		_SatAmount("Saturation Amount", Range(0.0, 1.0)) = 1.0
		_ConAmount ("Contrast Amount", Range(0.0, 1.0)) = 1.0
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
			uniform fixed _BrightnessAmount;
			uniform fixed _SatAmount;
			uniform fixed _ConAmount;
		
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
				return o;
			}

			float3 ContrastSaturationBrightness(float3 color, float brt, float sat, float con)
			{
				float avgLumR = 0.5;
				float avgLumG = 0.5;
				float avgLumB = 0.5;

				float3 luminanceCoeff = float3(0.2125, 0.7154, 0.0721);

				float3 avgLumin = float3(avgLumR, avgLumG, avgLumB);
				float3 brtColor = color * brt;
				float intensityF = dot(brtColor, luminanceCoeff);
				float3 intensity = float3(intensityF, intensityF, intensityF);

				float3 satColor = lerp(intensity, brtColor, sat);
				float3 conColor = lerp(avgLumin, satColor, con);

				return conColor;
			}

			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 col = tex2D(_MainTex, i.uv);
				col.rgb = ContrastSaturationBrightness(col.rgb, _BrightnessAmount, _SatAmount, _ConAmount);
				return col;
			}
			ENDCG
		}
	}
}
