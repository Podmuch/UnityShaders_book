Shader "PDGames/ToonMapping" 
{
	Properties 
	{
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_RampTex("Ramp", 2D) = "white" {}
		_CelShadingLevels ("Shading Levels", Range(2,100)) = 0.5
	}
	SubShader 
	{
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Toon

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0


		struct Input 
		{
			float2 uv_MainTex;
		};

		sampler2D _MainTex;
		sampler2D _RampTex;
		fixed4 _Color;
		float _CelShadingLevels;

		void surf (Input IN, inout SurfaceOutput o) 
		{
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}

		half4 LightingToon(SurfaceOutput s, half3 lightDir, half atten)
		{
			half NdotL = dot(s.Normal, lightDir);
			//NdotL = tex2D(_RampTex, fixed2(NdotL, 0.5));
			NdotL = floor(NdotL * _CelShadingLevels) / (_CelShadingLevels - 0.5); // Snap
			NdotL = NdotL*0.5f + 0.5f;
			NdotL = NdotL*NdotL;
			fixed4 c;
			c.rgb = s.Albedo * _LightColor0.rgb * NdotL * atten;
			c.a = s.Alpha;
			return c;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
