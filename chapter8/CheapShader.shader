Shader "Custom/CheapShader" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_BlendTex ("B (RGB)", 2D) = "white" {}
		_NormalMap("N Map",2D)= ""{}
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf SimpleLambert exclude_path:prepass noforwardadd

		sampler2D _MainTex;
		sampler2D _BlendTex;
		sampler2D _NormalMap;

		struct Input {
			// float2 uv_MainTex;
			// float2 uv_NormalMap;
			half2 uv_MainTex;
			//half2 uv_NormalMap;
		};
		
		// inline float4 LightingSimpleLambert(SurfaceOutput s,float3 lightDir,float atten)
		inline fixed4 LightingSimpleLambert(SurfaceOutput s,fixed3 lightDir,fixed atten)
		{
			fixed diff = max(0,dot(s.Normal,lightDir));
			
			fixed4 c;
			c.rgb = s.Albedo*_LightColor0.rgb*diff*atten*2;
			c.a = s.Alpha;
			return c;
		}

		void surf (Input IN, inout SurfaceOutput o) {
			//float4 c = tex2D (_MainTex, IN.uv_MainTex);
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
			fixed4 blendTex = tex2D(_BlendTex,IN.uv_MainTex);
			
			c = lerp(c,blendTex,blendTex.r);
			
			o.Albedo = c.rgb;
			o.Alpha = c.a;
			o.Normal = UnpackNormal(tex2D(_NormalMap,IN.uv_MainTex));
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
