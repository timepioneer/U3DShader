Shader "Custom/psLevel" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		
		_inBlack("Input Black",Range(0,255))=0
		_inGamma("Input Gamma",Range(0,2))=1.61
		_inWhite("Input White",Range(0,255))=255
		_outWhite("Output White",Range(0,255))=255
		_outBlack("Output Black",Range(0,255))=0
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Lambert

		sampler2D _MainTex;
		
		float _inBlack;
		float _inGamma;
		float _inWhite;
		float _outWhite;
		float _outBlack;

		struct Input {
			float2 uv_MainTex;
		};
		
		float GetPixelLevel(float pixelColor)
		{
			float pixelResult = pixelColor*255.0;
			pixelResult = max(0,pixelResult-_inBlack);
			float a = pixelResult/ (_inWhite - _inBlack);
			pixelResult = pow(a, _inGamma);
			//pixelResult = a*0.8;
			pixelResult = saturate(pixelResult);
			pixelResult = (pixelResult*(_outWhite-_outBlack)+_outBlack)/255.0;
			return pixelResult;
		}

		void surf (Input IN, inout SurfaceOutput o) {
		
		
			half4 c = tex2D (_MainTex, IN.uv_MainTex);
			half4 finalColor;
			finalColor.r = GetPixelLevel(c.r);
			finalColor.g = GetPixelLevel(c.g);
			finalColor.b = GetPixelLevel(c.b);

			//o.Albedo = c.rgb;
			o.Albedo = finalColor.rgb;
			o.Alpha = c.a;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
