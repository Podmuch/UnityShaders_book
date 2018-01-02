Shader "PDGames/SpecularBlinnPhong" 
{
	Properties
	{
		_MainTint("Diffuse Tint", Color) = (1,1,1,1)
		_MainTex("Base (RGB)", 2D) = "white" {}
		_SpecularColor("Specular Color", Color) = (1,1,1,1)
		_SpecPower("Specular Power", Range(0,30)) = 1
	}
	SubShader 
	{
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf CustomBlinnPhong

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		struct Input 
		{
			float2 uv_MainTex;
		};

		float4 _SpecularColor;
		sampler2D _MainTex;
		float4 _MainTint;
		float _SpecPower;

		void surf (Input IN, inout SurfaceOutput o) {
			// Albedo comes from a texture tinted by color
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _MainTint;
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}

		fixed4 LightingCustomBlinnPhong(SurfaceOutput s, fixed3 lightDir, half3 viewDir, fixed atten)
		{
			float NdotL = max(0, dot(s.Normal, lightDir));
			float3 diffuse = s.Albedo * max(0, NdotL) * atten;
			//Specular
			float3 halfVector = normalize(lightDir + viewDir);
			float NdotH = max(0, dot(s.Normal, halfVector));
			float spec = pow(NdotH, _SpecPower) * _SpecularColor;
			float3 finalSpec = _SpecularColor.rgb * spec;
			float4 c;
			c.rgb = _LightColor0.rgb * (diffuse + finalSpec);
			c.a = s.Alpha;
			return c;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
