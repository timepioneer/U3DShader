Shader "Custom/normalMap" {
	Properties {
		//_MainTex ("Base (RGB)", 2D) = "white" {}
		_MainTint("Diffuse Tint",Color)=(1,1,1,1)
		_NormalTex("Normal Map",2D)="bump"{}
		_NormalMapIntensity("Normal Map Intensity",Range(0,10))=1
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Lambert

		//sampler2D _MainTex;
		sampler2D _NormalTex;
		float4 _MainTint;
		float _NormalMapIntensity;

		struct Input {
			//float2 uv_MainTex;
			float2 uv_NormalTex;
		};

		void surf (Input IN, inout SurfaceOutput o) {
			float3 normalMap = UnpackNormal(tex2D(_NormalTex,IN.uv_NormalTex));
			normalMap = float3(normalMap.x*_NormalMapIntensity,normalMap.y*_NormalMapIntensity,normalMap.z);
			
			o.Normal = normalMap.rgb;
			//half4 c = tex2D (_MainTex, IN.uv_MainTex);
			o.Albedo = _MainTint.rgb;
			o.Alpha = _MainTint.a;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
