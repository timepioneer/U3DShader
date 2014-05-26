Shader "Custom/CubeMapShaderA" {
	Properties {
		_MainTint("D",Color)=(1,1,1,1)
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_Cubemap("CubeMap",CUBE)=""{}
		_ReflAmount("Reflaction Amount",Range(0.01,1))=0.5
		_ReflMask("R Mask",2D) = ""{}
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Lambert

		sampler2D _MainTex;
		sampler2D _ReflMask;
		samplerCUBE _Cubemap;
		float4 _MainTint;
		float _ReflAmount;

		struct Input {
			float2 uv_MainTex;
			float3 worldRefl;
		};

		void surf (Input IN, inout SurfaceOutput o) {
			half4 c = tex2D (_MainTex, IN.uv_MainTex);
			float3 reflection = texCUBE(_Cubemap,IN.worldRefl).rgb;
			float4 reflMask = tex2D(_ReflMask,IN.uv_MainTex);
			
			o.Albedo = c.rgb*_MainTint;
			o.Emission = reflection*reflMask.r*_ReflAmount;
			o.Alpha = c.a;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
