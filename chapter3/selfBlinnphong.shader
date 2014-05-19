Shader "Custom/slefBlinnPhong" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_MainTint("D",Color)=(1,1,1,1)
		_SpecColor("SC",Color)=(1,1,1,1)
		_SpecPower("SP",Range(0.1,60))=3
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf CustomBlinnPhong

		sampler2D _MainTex;
		float _SpecPower;
		float4 _MainTint;

		struct Input {
			float2 uv_MainTex;
		};
		
		inline fixed4 LightingCustomBlinnPhong(SurfaceOutput s, fixed3 lightDir, half3 viewDir, fixed atten)
		{
			float3 halfVector = normalize(lightDir+viewDir);
			
			float diff = max(0,dot(s.Normal,lightDir));
			float nh = max(0,dot(s.Normal,halfVector));
			float spec = pow(nh,_SpecPower)*_SpecColor;
			
			float4 c;
			c.rgb = (s.Albedo*_LightColor0.rgb*diff)+(_LightColor0.rgb*_SpecColor.rgb*spec)*atten*2;
			c.a=s.Alpha;
			return c;
		}

		void surf (Input IN, inout SurfaceOutput o) {
			half4 c = tex2D (_MainTex, IN.uv_MainTex)*_MainTint;
			//o.Specular = _SpecPower;
			//o.Gloss = 1.0;
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
