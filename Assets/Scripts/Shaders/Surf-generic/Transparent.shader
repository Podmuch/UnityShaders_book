Shader "PDGames/Transparent" {
	Properties
	{
		_Color("Color", Color) = (1,1,1,1)
		_MainTex("MainTex", 2D) = "white" {}
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
		#pragma surface surf Standard alpha:fade
		#pragma target 3.0

		struct Input
		{
			float2 uv_MainTex;
		};

		fixed4 _Color;
		sampler2D _MainTex;

		void surf(Input IN, inout SurfaceOutputStandard o)
		{
			float4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
