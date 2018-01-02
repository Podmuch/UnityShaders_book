Shader "PDGames/Silhouette" 
{
	Properties
	{
		_Color("Color", Color) = (1,1,1,1)
		_MainTex("MainTex", 2D) = "white" {}
		_DotProduct("Rim effect", Range(-1,1)) = 0.25
	}
		SubShader
	{
		Tags
		{
			"Queue" = "Transparent"
			"IgnoreProjector" = "True"
			"RenderType" = "Transparent"
		}
		LOD 200
		Cull Back
		// We need to declare the properties variable type inside of the
		// CGPROGRAM so we can access its value from the properties block.
		CGPROGRAM
		#pragma surface surf Lambert alpha:fade 
		#pragma target 3.0

		struct Input
		{
			float2 uv_MainTex;
			float3 worldNormal;
			float3 viewDir;
		};

		fixed4 _Color;
		sampler2D _MainTex;
		float _DotProduct;

		void surf(Input IN, inout SurfaceOutput o)
		{
			float4 c = tex2D(_MainTex, IN.uv_MainTex);
			float border = 1 - (abs(dot(IN.viewDir, IN.worldNormal)));
			float alpha = (border * (1 - _DotProduct) + _DotProduct);
			o.Albedo =  normalize(c.rgb + _Color.rgb * alpha);
			o.Alpha = c.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
