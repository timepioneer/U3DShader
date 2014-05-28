Shader "Custom/vertexTerrain" {
	Properties {
		_MainTex ("Base Color", 2D) = "white"{}
		_SecondaryTex("S T",2D)="white"{}
		_HeightMap("H M",2D)=""{}
		_Value("Value",Range(1,20))=3
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Lambert vertex:vert

		sampler2D _MainTex;
		sampler2D _SecondaryTex;
		sampler2D _HeightMap;
		float _Value;

		struct Input {
			float2 uv_MainTex;
			float2 uv_SecondaryTex;
			float3 vertColor;
		};
		
		void vert(inout appdata_full v,out Input o)
		{
			o.vertColor = v.color.rgb;
		}

		void surf (Input IN, inout SurfaceOutput o) 
		{
			half4 base = tex2D(_MainTex,IN.uv_MainTex);
			half4 secondaryTex = tex2D(_SecondaryTex,IN.uv_SecondaryTex);
			float4 height = tex2D(_HeightMap,IN.uv_MainTex);
			
			float redChannel = 1-IN.vertColor.r;
			float rheight = height.r*redChannel;
			float invertHeight = 1-height.r;
			float finalHeight = (invertHeight*redChannel)*4;
			float finalBlend = saturate(rheight+finalHeight);
			
			float hardness= ((1-IN.vertColor.g)*_Value)+1;
			finalBlend = pow(finalBlend,hardness);
			
			float3 finalColor = lerp(base,secondaryTex,finalBlend);
			
			o.Albedo = finalColor;
			o.Alpha = base.a;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
