﻿Shader "Custom/terrainShader" {
	Properties {
		//_MainTex ("Base (RGB)", 2D) = "white" {}
		
		_MainTint ("Diffuse Tint",Color)=(1,1,1,1)
		
		_ColorA("Terrain Color A",Color)=(1,1,1,1)
		_ColorB("Terrain Color B",Color)=(1,1,1,1)
		_RTexture("Red Channel Texture",2D)=""{}
		_GTexture("Green Channel Texture",2D)=""{}
		_BTexture("Blue Channel Texture",2D)=""{}
		_ATexture("Alpha Channel Texture",2D)=""{}
		_BlendTex("Blend Texture",2D)=""{}
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Lambert

		//sampler2D _MainTex;
		
		float4 _MainTint;
		float4 _ColorA;
		float4 _ColorB;
		sampler2D _RTexture;
		sampler2D _GTexture;
		sampler2D _BTexture;
		sampler2D _ATexture;
		sampler2D _BlendTex; 

		struct Input {
			float2 uv_RTexture;
			float2 uv_GTexture;
			float2 uv_BTexture;
			float2 uv_ATexture;
			float2 uv_BlendTex;
		};

		void surf (Input IN, inout SurfaceOutput o) {
			//half4 c = tex2D (_MainTex, IN.uv_MainTex);
			
			half4 blendData = tex2D(_BlendTex,IN.uv_BlendTex);
			
			half4 rTexData = tex2D(_RTexture,IN.uv_RTexture);
			half4 gTexData = tex2D(_GTexture,IN.uv_GTexture);
			half4 bTexData = tex2D(_BTexture,IN.uv_BTexture);
			half4 aTexData = tex2D(_ATexture,IN.uv_ATexture);
			 
			float4 finalColor = lerp(rTexData,gTexData,blendData.g);
			finalColor = lerp(finalColor,bTexData,bTexData.b);
			finalColor = lerp(finalColor,aTexData,blendData.a);
			finalColor.a = 1.0;
			
			float4 terrainLayers = lerp(_ColorA,_ColorB,blendData.r);
			finalColor *= terrainLayers;
			finalColor = saturate(finalColor);
			
			o.Albedo = finalColor.rgb * _MainTint.rgb;
			//o.Albedo = bTexData.rgb;
			o.Alpha = finalColor.a;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
