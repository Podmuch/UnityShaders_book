Shader "PDGames/MobileSpecular"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_SpecIntensity ("Specular Width", Range(0.01, 1)) = 0.5
		_NormalMap("Normal Map", 2D) = "bump" {}
	}
	SubShader
	{
		CGPROGRAM
		#pragma surface surf MobileBlinnPhong exclude_path:prepass nolightmap noforwardadd halfasview

		#include "UnityCG.cginc"

		sampler2D _MainTex;
		sampler2D _NormalMap;
		fixed _SpecIntensity;

		struct Input
		{
			half2 uv_MainTex;
		};

		inline fixed4 LightingMobileBlinnPhong(SurfaceOutput s, fixed3 lightDir, fixed3 halfDir, fixed atten)
		{
			fixed diff = max(0, dot(s.Normal, lightDir));
			fixed nh = max(0, dot(s.Normal, halfDir));
			fixed spec = pow(nh, s.Specular * 128) * s.Gloss;
			fixed4 c;
			c.rgb = (s.Albedo * _LightColor0.rgb * diff + _LightColor0.rgb * spec) * atten;
			c.a = 0.0;
			return c;
		}

		void surf(Input IN, inout SurfaceOutput o)
		{
			fixed4 diffuseTex = tex2D(_MainTex, IN.uv_MainTex);
			o.Albedo = diffuseTex.rgb;
			o.Gloss = diffuseTex.a;
			o.Alpha = 0.0;
			o.Specular = _SpecIntensity;
			o.Normal = UnpackNormal(tex2D(_NormalMap, IN.uv_MainTex));
		}
		ENDCG
	}
}
