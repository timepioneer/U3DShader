Shader "Custom/CubeMapShaderNormal" {
	Properties {
		_MainTint("D",Color)=(1,1,1,1)
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_Cubemap("CubeMap",CUBE)=""{}
		_ReflAmount("Reflaction Amount",Range(0.01,1))=0.5
		_NormalMap("N Map",2D) = ""{}
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Lambert

		sampler2D _MainTex;
		sampler2D _NormalMap;
		samplerCUBE _Cubemap;
		float4 _MainTint;
		float _ReflAmount;

		struct Input {
			float2 uv_MainTex;
			float2 uv_NormalMap;
			float3 worldRefl;
			INTERNAL_DATA
		};

		void surf (Input IN, inout SurfaceOutput o) {
			half4 c = tex2D (_MainTex, IN.uv_MainTex);
			float3 normals = UnpackNormal(tex2D(_NormalMap,IN.uv_NormalMap)).rgb;
			
			o.Normal = normals;			
			o.Emission = texCUBE(_Cubemap,WorldReflectionVector(IN,o.Normal)).rgb*_ReflAmount;
			o.Albedo = c.rgb*_MainTint;
			o.Alpha = c.a;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
