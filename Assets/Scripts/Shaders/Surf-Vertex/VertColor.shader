Shader "PDGames/VertColor" 
{
	Properties 
	{ 
		_MainTint("Global Color Tint", Color) = (1,1,1,1)
	}
	SubShader 
	{
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Lambert vertex:vert

		#pragma target 3.0

		struct Input 
		{
			float4 vertColor;
		};

		float4 _MainTint;

		void vert(inout appdata_full v, out Input o)
		{
			o.vertColor = v.color;
		}

		void surf(Input IN, inout SurfaceOutput o)
		{
			o.Albedo = IN.vertColor.rgb * _MainTint.rgb;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
