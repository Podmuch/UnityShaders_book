Shader "PDGames/Lambert" {
	Properties 
	{
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
	}
	SubShader 
	{
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf SimpleLambert

		#pragma target 3.0

		sampler2D _MainTex;

		struct Input 
		{
			float2 uv_MainTex;
		};

		void surf (Input IN, inout SurfaceOutput o) {
			o.Albedo = tex2D(_MainTex, IN.uv_MainTex).rgb;
		}

		half4 LightingSimpleLambert(SurfaceOutput s, half3 lightDir, half atten) 
		{
			half NdotL = dot(s.Normal, lightDir);
			NdotL = NdotL*0.5f + 0.5f;
			NdotL = NdotL*NdotL*NdotL;
			half4 c;
			c.rgb = s.Albedo * _LightColor0.rgb * (NdotL * atten);
			c.a = s.Alpha;
			return c;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
