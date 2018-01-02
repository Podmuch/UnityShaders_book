// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "PDGames/Heatmap"
{
	Properties 
	{
		_HeatTex ("Texture", 2D) = "white" {}
	}
	Subshader 
	{
		Tags {"Queue"="Transparent"}
		Blend SrcAlpha OneMinusSrcAlpha // Alpha blend

		Pass 
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			struct vertInput 
			{
				float4 pos : POSITION;
				float4 texcoord : TEXCOORD0;
			};

			struct vertOutput 
			{
				float4 pos : POSITION;
				float4 texcoord : TEXCOORD0;
				fixed3 worldPos : TEXCOORD1;
			};

			vertOutput vert(vertInput input) 
			{
				vertOutput o;
				o.pos = mul(UNITY_MATRIX_MVP, input.pos);
				o.texcoord = input.texcoord;
				o.worldPos = mul(unity_ObjectToWorld, input.pos).xyz;
				return o;
			}

			uniform int _Points_Length = 0;
			uniform float3 _Points[20];
			// (x, y, z) = position
			uniform float2 _Properties[20];
			// x = radius, y = intensity
			sampler2D _HeatTex;

			half4 frag(vertOutput output) : COLOR 
			{
				// Loops over all the points
				half h = 0;
				for (int i = 0; i < _Points_Length; i++)
				{
					// Calculates the contribution of each point
					half di = length(output.texcoord.xy - _Points[i].xy);
					half ri = _Properties[i].x;
					half hi = 1 - saturate(di / ri);
					h += hi * _Properties[i].y;
				}
				// Converts (0-1) according to the heat texture
				h = saturate(h);
				half4 color = tex2D(_HeatTex, fixed2(h, 0.5));
				return color;
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
}
