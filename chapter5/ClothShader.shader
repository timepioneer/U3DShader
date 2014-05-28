Shader "Custom/ClothShader" {
	Properties {
		_MainTint("D T",Color)=(1,1,1,1)
		//_MainTex ("Base", 2D) = "white" {}
		_BumpMap ("Normal Map", 2D) = "" {}
		_DetailBump ("D B Map", 2D) = "" {}
		_DetailTex ("Fabric weave", 2D) = "white" {}
		_FresnelColor("F Color",Color)=(1,1,1,1)
		_FresnelPower("F Power",Range(0,12))=3
		_RimPower("Rim Falloff",Range(0,5))=3
		_SpecIntensity("SP I",Range(0,1))=0.2
		_SpecWidth("Specular W",Range(0,1))=0.2
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Velvet
		#pragma target 3.0
		
		sampler2D _BumpMap;
		sampler2D _DetailBump;
		sampler2D _DetailTex;
		float4 _MainTint;
		float4 _FresnelColor;
		float _FresnelPower;
		float _RimPower;
		float _SpecIntensity;
		float _SpecWidth;

		struct Input {
			float2 uv_BumpMap;
			float2 uv_DetailBump;
			float2 uv_DetailTex;
		};
		
		inline fixed4 LightingVelvet(SurfaceOutput s,fixed3 lightDir,fixed3 viewDir,fixed atten)
		{
			viewDir = normalize(viewDir);
			lightDir = normalize(lightDir);
			float3 halfVec = normalize(lightDir+viewDir);
			fixed NdotL = max(0,dot(s.Normal,lightDir));
			
			float NdotH = max(0,dot(s.Normal,halfVec));
			float spec = pow(NdotH,s.Specular*128.0)*s.Gloss;
			
			float HdotV = pow(1-max(0,dot(halfVec,viewDir)),_FresnelPower);
			float NdotE = pow(1-max(0,dot(s.Normal,viewDir)),_RimPower);
			float finalSpecMask = NdotE*HdotV;
			
			fixed4 c;
			c.rgb = (s.Albedo*NdotL*_LightColor0.rgb)+
						(spec*(finalSpecMask*_FresnelColor))*(atten*2);
			c.a = 1.0f;
			return c;
		}

		void surf (Input IN, inout SurfaceOutput o) 
		{
			half4 c = tex2D(_DetailTex,IN.uv_DetailTex);
			fixed3 normals = UnpackNormal(tex2D(_BumpMap,IN.uv_BumpMap)).rgb;
			fixed3 detailNormals = UnpackNormal(tex2D(_DetailBump,IN.uv_DetailBump)).rgb;
			fixed3 finalNormals = float3(normals.x+detailNormals.x,
											normals.y+detailNormals.y,
											normals.z+detailNormals.z);
			
			o.Normal = normalize(finalNormals);
			o.Specular = _SpecWidth;	
			o.Albedo = c.rgb*_MainTint;
			o.Specular = _SpecWidth;
			o.Gloss = _SpecIntensity;
			o.Alpha = c.a;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
