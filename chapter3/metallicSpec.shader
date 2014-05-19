Shader "Custom/metalicSpec" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_RoughnessTex ("Rough", 2D) = "white" {}
		_Roughness("Roughness",Range(0,1))=0.5
		_MainTint("D",Color)=(1,1,1,1)
		_SpecularColor("SC",Color)=(1,1,1,1)
		_SpecPower("SP",Range(0,30))=2
		_Fresnel("Fresnel Value",Range(0,1.0))=0.05
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf MetallicSoft
		#pragma target 3.0

		sampler2D _MainTex;
		sampler2D _RoughnessTex;
		float _Roughness;
		float _Fresnel;
		float _SpecPower;
		float4 _MainTint;
		float4 _SpecularColor;

		struct Input {
			float2 uv_MainTex;
			float2 uv_RoughnessTex;
		};
		
		inline fixed4 LightingMetallicSoft(SurfaceOutput s, fixed3 lightDir, half3 viewDir, fixed atten)
		{	
			float3 halfVector = normalize(lightDir+viewDir);
			float NdotL = saturate(dot(s.Normal,normalize(lightDir)));
			float NdotH_raw = dot(s.Normal,halfVector);
			float NdotH = saturate(dot(s.Normal,halfVector));
			float NdotV = saturate(dot(s.Normal,normalize(viewDir)));
			float VdotH = saturate(dot(halfVector,normalize(viewDir)));
			
			float geoEnum = 2.0*NdotH;
			float3 G1 = (geoEnum*NdotV)/NdotH;
			float3 G2 = (geoEnum*NdotL)/NdotH;
			float3 G = min(1.0f,min(G1,G2));
			
			float roughness = tex2D(_RoughnessTex,float2(NdotH_raw*0.5+0.5,_Roughness)).r;
			
			float fresnel = pow(1.0-VdotH,5.0);
			fresnel *= (1.0-_Fresnel);
			fresnel += _Fresnel;
			
			float3 spec = float3(fresnel*G*roughness*roughness)*_SpecPower;
			
			float4 c;
			c.rgb = (s.Albedo*_LightColor0.rgb*NdotL)+(spec*_SpecularColor.rgb)*(atten*2.0f);
			c.a=s.Alpha;
			return c;
		}

		void surf (Input IN, inout SurfaceOutput o) {
			float4 c = tex2D (_MainTex, IN.uv_MainTex)*_MainTint;
			
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
