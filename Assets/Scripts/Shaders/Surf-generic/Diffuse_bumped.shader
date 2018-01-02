Shader "PDGames/Diffuse_bumped" {
	Properties
	{
		_Color("Color", Color) = (1,1,1,1)
		_NormalTex("Normal Map", 2D) = "bump" {}
		_NormalMapIntensity("Normal intensity", Float) = 1
	}
	SubShader
	{
		Tags{ "RenderType" = "Opaque" }
		LOD 200
		// We need to declare the properties variable type inside of the
		// CGPROGRAM so we can access its value from the properties block.
		CGPROGRAM
		#pragma surface surf Lambert
		#pragma target 3.0

		struct Input
		{
			float2 uv_NormalTex;
		};

		fixed4 _Color;
		sampler2D _NormalTex;
		float _NormalMapIntensity;

		void surf(Input IN, inout SurfaceOutput o)
		{
			float3 normalMap = UnpackNormal(tex2D(_NormalTex, IN.uv_NormalTex));
			normalMap.xy *= _NormalMapIntensity;
			o.Normal = normalize(normalMap.rgb);
			o.Albedo = _Color.rgb;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
