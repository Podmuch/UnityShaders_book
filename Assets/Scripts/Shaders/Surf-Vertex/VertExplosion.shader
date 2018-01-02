Shader "PDGames/VertExplosion" 
{
	Properties 
	{
		_RampTex("Color Ramp", 2D) = "white" {}
		_RampOffset("Ramp offset", Range(-1, 1)) = 0
		_NoiseTex("Noise tex", 2D) = "gray" {}
		_Period("_Period", Range(0,10)) = 0.5
		_Speed("Speed", Range(0, 10)) = 0.5
		_Strength("Strength", Range(0, 1)) = 0.5
		_Amount("Amount", Range(0, 10.0)) = 0.1
		_CurTime("_CurTime", float) = 0
		_ClipRange("ClipRange", Range(0,1)) = 1
	}
	SubShader 
	{
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM

		#pragma surface surf Lambert vertex:vert nolightmap

		#pragma target 3.0

		sampler2D _RampTex;
		sampler2D _NoiseTex;
		half _RampOffset;
		uniform float _Period;
		uniform float _CurTime;
		float _Speed;
		float _Strength;
		half _Amount;
		half _ClipRange;

		struct Input 
		{
			float2 uv_NoiseTex;
			float distance;
			float animFactor;
		};

		void vert(inout appdata_full v, out Input o)
		{
			float texCoordX = v.texcoord.x + sin(_CurTime * _Speed);
			if (texCoordX > 1) texCoordX -= 1;
			else if (texCoordX < 0) texCoordX += 1;
			float3 disp = tex2Dlod(_NoiseTex, float4(texCoordX, v.texcoord.y, 0, 0));
			float time = _CurTime - floor(_CurTime / _Period) * _Period;
			time = (time / _Period);
			time = 1 + time * 3;
			time = log2(time)*0.5;
			time *= disp.r;
			v.vertex.xyz = v.normal * disp.r * _Amount * time;
			o.uv_NoiseTex = v.texcoord.xy;
			o.distance = length(v.vertex.xyz) / (_Amount* _Strength);
			o.animFactor = (_Period - _CurTime)/ _Period;
		}

		void surf (Input IN, inout SurfaceOutput o)
		{
			clip(IN.animFactor);
			float3 noise = tex2D(_NoiseTex, IN.uv_NoiseTex);
			float n = saturate(_RampOffset - noise.r);
			clip(_ClipRange - IN.distance);
			clip(IN.distance - (1.0*(1 - IN.animFactor)));
			half4 c = tex2D(_RampTex, float2(IN.distance*IN.distance*2, 0.5));
			o.Albedo = c.rgb;
			o.Emission = c.rgb*c.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
