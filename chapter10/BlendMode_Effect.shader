Shader "Custom/BlendMode_Effect" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_BlendTex ("B T",2D)="white"{}
		_Opacity("B O",Range(0,1))=1
	}
	SubShader {
		Pass{
		
		CGPROGRAM
		#pragma vertex vert_img
		#pragma fragment frag
		#pragma fragmentoption ARB_precison_hint_fastest
		#include "UnityCG.cginc"

		uniform sampler2D _MainTex;
		uniform sampler2D _BlendTex;
		fixed _Opacity;

		fixed4 frag(v2f_img i):COLOR
		{
			fixed4 renderTex = tex2D(_MainTex,i.uv);
			fixed4 blendTex = tex2D(_BlendTex,i.uv);
			
			// fixed4 blendedMultipy = renderTex*blendTex;
			// fixed4 blendedMultipy = renderTex+blendTex;
			fixed4 blendedMultipy = (1.0-((1.0-renderTex)*(1.0-blendTex)));
			
			renderTex = lerp(renderTex,blendedMultipy,_Opacity);
															
			return renderTex;
		}
		ENDCG
		}
	} 
	FallBack "Diffuse"
}
