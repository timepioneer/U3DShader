Shader "Custom/OldFilmEffectShader" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_VignetteTex("V T",2D)=""{}
		_ScratchesTex("S T",2D)=""{}
		_DustTex("D t",2D)=""{}
		_SepiaColor("S C",Color)=(1,1,1,1)
		_EffectAmount("E A",Range(0,1))=1.0
		_VignetteAmount("V A",Range(0,1))=1.0
		_ScratchesYSpeed("S Y S",Float)=10.0
		_ScratchesXSpeed("S X S",Float)=10.0
		_dustYSpeed("D Y S",Float)=10.0
		_dustXSpeed("D X S",Float)=10.0
		_RandomValue("Random V",Float)=1.0
	}
	SubShader {
		Pass{		
		CGPROGRAM
		#pragma vertex vert_img
		#pragma fragment frag
		#pragma fragmentoption ARB_precison_hint_fastest
		#include "UnityCG.cginc"

		uniform sampler2D _MainTex;
		uniform sampler2D _VignetteTex;
		uniform sampler2D _ScratchesTex;
		uniform sampler2D _DustTex;
		fixed4 _SepiaColor;
		fixed _VignetteAmount;
		fixed _ScratchesYSpeed;
		fixed _ScratchesXSpeed;
		fixed _dustYSpeed;
		fixed _dustXSpeed;
		fixed _EffectAmount;
		fixed _RandomValue;

		fixed4 frag(v2f_img i):COLOR
		{
			half2 renderTexUV = half2(i.uv.x,i.uv.y+(_RandomValue*_SinTime.z*0.005));
			fixed4 renderTex = tex2D(_MainTex,renderTexUV);
			
			fixed4 vignetteTex = tex2D(_VignetteTex,i.uv);
			
			half2 scratchesUV = half2(i.uv.x+(_RandomValue*_SinTime.z*_ScratchesXSpeed),
								i.uv.y+(_Time.z*_ScratchesYSpeed));
			fixed4 scratchesTex = tex2D(_ScratchesTex,scratchesUV);
			
			half2 dustUV = half2(i.uv.x+(_RandomValue*(_SinTime.z*_dustXSpeed)),
								i.uv.y+(_RandomValue*(_SinTime.z*_dustYSpeed)));
			fixed4 dustTex = tex2D(_DustTex,dustUV);
								
			fixed lum = dot(fixed3(0.299,0.587,0.114),renderTex.rgb);
			
			fixed4 finalColor = lum+lerp(_SepiaColor,_SepiaColor+fixed4(0.1f,0.1f,0.1f,1.0f),_RandomValue);
			
			fixed3 constantWhite = fixed3(1,1,1);
			
			finalColor = lerp(finalColor,finalColor*vignetteTex,_VignetteAmount);
			finalColor.rgb*=lerp(scratchesTex,constantWhite,(_RandomValue));
			finalColor.rgb*=lerp(dustTex.rgb,constantWhite,(_RandomValue*_SinTime.z));
			finalColor = lerp(renderTex,finalColor,_EffectAmount);
															
			return finalColor;
		}
		ENDCG
		}
	} 
	FallBack "Diffuse"
}
