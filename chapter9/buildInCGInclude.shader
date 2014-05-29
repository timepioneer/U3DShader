Shader "Custom/buildInCGInclude" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_DesatValue("De",Range(0,1))=0.5
		_MyColor("M C",Color)=(1,1,1,1)
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		//#define HalfLambert
		#include "MyCGInclude.cginc"
		#pragma surface surf CustomLambert

		sampler2D _MainTex;
		fixed _DesatValue;

		struct Input {
			float2 uv_MainTex;
		};

		void surf (Input IN, inout SurfaceOutput o) {
			half4 c = tex2D (_MainTex, IN.uv_MainTex);
			
			c.rgb = lerp(c.rgb,Luminance(c.rgb),_DesatValue);
			
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
