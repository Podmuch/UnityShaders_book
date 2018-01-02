Shader "Hidden/PDGames/Overlay_Effect"
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

			fixed OverlayBlendMode(fixed basePixel, fixed blendPixel)
			{
				if (basePixel < 0.5)
				{
					return 2.0 * basePixel * blendPixel;
				}
				else
				{
					return (1.0 - 2.0 * (1.0 - basePixel) * (1.0 - blendPixel));
				}
			}

			fixed4 frag (v2f_img i) : SV_Target
			{
				fixed4 renderTex = tex2D(_MainTex, i.uv);
				fixed4 blendTex = tex2D(_BlendTex, i.uv);

				fixed4 blendedImage = renderTex;

				blendedImage.r = OverlayBlendMode(renderTex.r, blendTex.r);
				blendedImage.g = OverlayBlendMode(renderTex.g, blendTex.g);
				blendedImage.b = OverlayBlendMode(renderTex.b, blendTex.b);

				return lerp(renderTex, blendedImage, _Opacity);
			}
			ENDCG
		}
	}
}
