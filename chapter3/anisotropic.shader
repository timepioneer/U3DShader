﻿Shader "Custom/anisotrpoic" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}		
		_MainTint("D",Color)=(1,1,1,1)
		_SpecularColor("SC",Color)=(1,1,1,1)
		_Specular("Specular",Range(0,1))=0.5
		_SpecPower("SP",Range(0,1))=0.5
		_AnisoDir ("AnisoDir", 2D) = "white" {}
		_AnisoOffset("AnisoOffset",Range(-1,1))=-0.2
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Anisotropic
		#pragma target 3.0

		sampler2D _MainTex;
		sampler2D _AnisoDir;
		float _AnisoOffset;
		float _Specular;
		float _SpecPower;
		float4 _MainTint;
		float4 _SpecularColor;

		struct Input {
			float2 uv_MainTex;
			float2 uv_AnisoDir;
		};
		
		struct SurfaceAnisoOutput
		{
			fixed3 Albedo;
			fixed3 Normal;
			fixed3 Emission;
			fixed3 AnisoDirection;
			half Specular;
			fixed Gloss;
			fixed3 Alpha;
		};
		
		inline fixed4 LightingAnisotropic(SurfaceAnisoOutput s, fixed3 lightDir, half3 viewDir, fixed atten)
		{	
			fixed3 halfVector = normalize(normalize(lightDir)+normalize(viewDir));
			float NdotL = saturate(dot(s.Normal,lightDir));
			
			fixed HdotA = dot(normalize(s.Normal+s.AnisoDirection),halfVector);
			float aniso = max(0,sin(radians((HdotA+_AnisoOffset)*180f)));
			
			float spec = saturate(pow(aniso,s.Gloss*128)*s.Specular);
			
			float4 c;
			c.rgb = (s.Albedo*_LightColor0.rgb*NdotL)+(_LightColor0.rgb*_SpecularColor.rgb*spec);
			c.a=1.0;
			return c;
		}

		void surf (Input IN, inout SurfaceAnisoOutput o) 
		{
			half4 c = tex2D (_MainTex, IN.uv_MainTex)*_MainTint;
			float3 anisoTex = UnpackNormal(tex2D(_AnisoDir,IN.uv_AnisoDir));
			
			o.AnisoDirection = anisoTex;
			o.Specular = _Specular;
			o.Gloss = _SpecPower;
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}