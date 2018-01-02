Shader "Hidden/PDGames/BlendMode_Effect"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_BlendTex ("Blend texture", 2D) = "white" {}
		_Opacity ("Blend Opacity", Range(0, 1)) = 1
	}
	SubShader
	{
		Pass
		{
			CGPROGRAM
			#pragma vertex vert_img
			#pragma fragment frag
			#pragma fragmentoption ARB_precision_hint_fastest

			#include "UnityCG.cginc"

			uniform sampler2D _MainTex;
			uniform sampler2D _BlendTex;
			uniform fixed _Opacity;

			fixed4 frag (v2f_img i) : SV_Target
			{
				fixed4 renderTex = tex2D(_MainTex, i.uv);
				fixed4 blendTex = tex2D(_BlendTex, i.uv);

				//multiply
				//fixed4 blendedMultiply = renderTex * blendTex;
				//add
				//fixed4 blendedMultiply = renderTex + blendTex;
				//screenBlend
				fixed4 blendedMultiply = (1.0 - (1.0 -renderTex) * (1.0 - blendTex));

				return lerp(renderTex, blendedMultiply, _Opacity);
			}
			ENDCG
		}
	}
}
