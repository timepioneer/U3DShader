﻿Shader "Custom/SkinShader" {
	Properties {
		_MainTint("D T",Color)=(1,1,1,1)
		_MainTex ("Base", 2D) = "white" {}
		_BumpMap ("Normal Map", 2D) = "" {}
		_CurveScale("C Scale",Range(0.001,0.09))=0.01
		_CurveAmount("C Amount",Range(0,1))=0.5
		_BumpBias("B B",Range(0,5))=2.00
		_BRDF("BRDF Ramp",2D)="white"{}
		_FresnelVal("Fresnel Amount",Range(0.01,0.3))=0.05
		_RimPower("Rim Falloff",Range(0,5))=2
		_RimColor("Rim Color",Color)=(1,1,1,1)
		_SpecIntensity("SP I",Range(0,1))=0.4
		_SpecWidth("Specular W",Range(0,1))=0.2
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf SkinShader
		#pragma target 3.0
		#pragma only_renderers d3d9
		
		sampler2D _MainTex;
		sampler2D _BumpMap;
		sampler2D _BRDF;
		float4 _MainTint;
		float4 _RimColor;
		float _CurveScale;
		float _BumpBias;
		float _CurveAmount;
		float _FresnelVal;
		float _RimPower;
		float _SpecIntensity;
		float _SpecWidth;

		struct Input {
			float2 uv_MainTex;
			float3 worldPos;
			float3 worldNormal;
			INTERNAL_DATA
		};
		
		struct SurfaceOutputSkin
		{
			fixed3 Albedo;
			fixed3 Normal;
			fixed3 Emission;
			fixed3 Specular;
			fixed Gloss;
			fixed Alpha;
			float Curvature;
			fixed3 BlurredNormals;
		};
		
		inline fixed4 LightingSkinShader(SurfaceOutputSkin s,fixed3 lightDir,fixed3 viewDir,fixed atten)
		{
			viewDir = normalize(viewDir);
			lightDir = normalize(lightDir);
			s.Normal = normalize(s.Normal);
			float NdotL = dot(s.BlurredNormals,lightDir);
			float3 halfVec = normalize(lightDir+viewDir);
			
			float3 brdf = tex2D(_BRDF,float2((NdotL*0.5+0.5)*atten,s.Curvature)).rgb;
			
			float fresnel = saturate(pow(1-dot(viewDir,halfVec),5.0));
			fresnel +=_FresnelVal*(1-fresnel);
			float rim = saturate(pow(1-dot(viewDir,s.BlurredNormals),_RimPower))*fresnel;
			
			float specBase = max(0,dot(s.Normal,halfVec));
			float spec = pow(specBase,s.Specular*128.0)*s.Gloss;
			
			fixed4 c;
			c.rgb = s.Albedo*brdf*_LightColor0.rgb*atten+spec+rim*_RimColor;
			c.a = 1.0f;
			return c;
		}

		void surf (Input IN, inout SurfaceOutputSkin o) 
		{
			half4 c = tex2D(_MainTex,IN.uv_MainTex);
			fixed3 normals = UnpackNormal(tex2D(_BumpMap,IN.uv_MainTex));
			float3 normalBlur = UnpackNormal(tex2Dbias(_BumpMap,float4(IN.uv_MainTex,0.0,_BumpBias)));
			
			float curvature = length(fwidth(WorldNormalVector(IN,normalBlur)))
								/length(fwidth(IN.worldPos))*_CurveScale;
			
			o.Normal = normals;
			o.BlurredNormals = normalBlur;	
			o.Albedo = c.rgb*_MainTint;
			o.Curvature = curvature;
			o.Specular = _SpecWidth;
			o.Gloss = _SpecIntensity;
			o.Alpha = c.a;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
