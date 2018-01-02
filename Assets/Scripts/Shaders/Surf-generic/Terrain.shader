Shader "PDGames/Terrain" 
{
	Properties 
	{
		_MainTint("Diffuse Tint", Color) = (1,1,1,1)

		_GrassTexture("Grass(green)", 2D) = ""{}
		_SandTexture("Sand(red)", 2D) = ""{}
		_WaterTexture("Water(blue)", 2D) = ""{}
		_BlendTex("Blend Texture", 2D) = ""{}
	}
	SubShader 
	{
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma vertex vert
		#pragma surface surf Lambert

		#pragma target 3.0

		float4 _MainTint;
		sampler2D _GrassTexture;
		sampler2D _SandTexture;
		sampler2D _WaterTexture;
		sampler2D _BlendTex;

		struct Input 
		{
			float2 uv_GrassTexture;
			float2 uv_SandTexture;
			float2 uv_WaterTexture;
			float2 uv_BlendTex;
		};

		void vert(inout appdata_full v, out Input o)
		{
			UNITY_INITIALIZE_OUTPUT(Input, o);
			float4 blendData = tex2Dlod(_BlendTex, float4(v.texcoord.xy, 0,0));
			blendData.a = blendData.a * 2 - 1.0;
			v.vertex.xyz += v.normal*blendData.a;
		}

		void surf (Input IN, inout SurfaceOutput o) 
		{
			float4 blendData = tex2D(_BlendTex, IN.uv_BlendTex);

			float4 grassData = tex2D(_GrassTexture, IN.uv_GrassTexture);
			float4 sandData = tex2D(_SandTexture, IN.uv_SandTexture);
			float4 waterData = tex2D(_WaterTexture, IN.uv_WaterTexture);

			float3 grassAlbedo = grassData.rgb * blendData.g;
			float3 sandAlbedo = sandData.rgb * blendData.r;
			float3 waterAlbedo = waterData.rgb * blendData.b;

			o.Albedo = saturate(grassAlbedo + sandAlbedo + waterAlbedo) * _MainTint.rgb;
			o.Alpha = _MainTint.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
