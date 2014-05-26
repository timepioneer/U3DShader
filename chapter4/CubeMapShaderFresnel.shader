Shader "Custom/CubeMapShaderFresnel" {
	Properties {
		_MainTint("D",Color)=(1,1,1,1)
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_Cubemap("CubeMap",CUBE)=""{}
		_ReflectionAmount("Reflaction Amount",Range(0.01,1))=0.5
		_RimPower("Fresnel Falloff",Range(0.1,3))=2
		_SpecColor("SP C",Color)=(1,1,1,1)
		_SpecPower("SP Power",Range(0,1))=0.5
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf BlinnPhong
		#pragma target 3.0

		sampler2D _MainTex;
		samplerCUBE _Cubemap;
		float4 _MainTint;
		float _ReflectionAmount;
		float _RimPower;
		float _SpecPower;

		struct Input {
			float2 uv_MainTex;
			float3 worldRefl;
			float3 viewDir;
		};

		void surf (Input IN, inout SurfaceOutput o) {
			half4 c = tex2D (_MainTex, IN.uv_MainTex);
			
			float rim = 1.0-saturate(dot(o.Normal,normalize(IN.viewDir)));
			rim = pow(rim,_RimPower);
			
			o.Albedo = c.rgb*_MainTint;
			o.Emission = (texCUBE(_Cubemap,IN.worldRefl).rgb*_ReflectionAmount)*rim;
			o.Specular = _SpecPower;
			o.Gloss = 1.0;
			o.Alpha = c.a;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
