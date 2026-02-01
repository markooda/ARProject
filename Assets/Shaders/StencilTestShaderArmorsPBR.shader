Shader "Polytope Studio/ PT_Medieval Armors Shader PBR (Stencil)"
{
	Properties
	{
		[HDR]_SKINCOLOR("SKIN COLOR", Color) = (2.02193,1.0081,0.6199315,0)
		_SKINSMOOTHNESS("SKIN SMOOTHNESS", Range( 0 , 1)) = 0.3
		[HDR]_EYESCOLOR("EYES COLOR", Color) = (0.0734529,0.1320755,0.05046281,1)
		_EYESSMOOTHNESS("EYES SMOOTHNESS", Range( 0 , 1)) = 0.7
		[HDR]_HAIRCOLOR("HAIR COLOR", Color) = (0.5943396,0.3518379,0.1093361,0)
		_HAIRSMOOTHNESS("HAIR SMOOTHNESS", Range( 0 , 1)) = 0.1
		[HDR]_SCLERACOLOR("SCLERA COLOR", Color) = (0.9056604,0.8159487,0.8159487,0)
		_SCLERASMOOTHNESS("SCLERA SMOOTHNESS", Range( 0 , 1)) = 0.5
		[HDR]_LIPSCOLOR("LIPS COLOR", Color) = (0.8301887,0.3185886,0.2780349,0)
		_LIPSSMOOTHNESS("LIPS SMOOTHNESS", Range( 0 , 1)) = 0.4
		[HDR]_SCARSCOLOR("SCARS COLOR", Color) = (0.8490566,0.5037117,0.3884835,0)
		_SCARSSMOOTHNESS("SCARS SMOOTHNESS", Range( 0 , 1)) = 0.3
		[HDR]_METAL1COLOR("METAL 1 COLOR", Color) = (2,0.682353,0.1960784,0)
		_METAL1METALLIC("METAL 1 METALLIC", Range( 0 , 1)) = 0.65
		_METAL1SMOOTHNESS("METAL 1 SMOOTHNESS", Range( 0 , 1)) = 0.7
		[HDR]_METAL2COLOR("METAL 2 COLOR", Color) = (0.4674706,0.4677705,0.5188679,0)
		_METAL2METALLIC("METAL 2 METALLIC", Range( 0 , 1)) = 0.65
		_METAL2SMOOTHNESS("METAL 2 SMOOTHNESS", Range( 0 , 1)) = 0.7
		[HDR]_METAL3COLOR("METAL 3 COLOR", Color) = (0.4383232,0.4383232,0.4716981,0)
		_METAL3METALLIC("METAL 3 METALLIC", Range( 0 , 1)) = 0.65
		_METAL3SMOOTHNESS("METAL 3 SMOOTHNESS", Range( 0 , 1)) = 0.7
		[HDR]_LEATHER1COLOR("LEATHER 1 COLOR", Color) = (0.4811321,0.2041155,0.08851016,1)
		_LEATHER1SMOOTHNESS("LEATHER 1 SMOOTHNESS", Range( 0 , 1)) = 0.3
		[HDR]_LEATHER2COLOR("LEATHER 2 COLOR", Color) = (0.4245283,0.190437,0.09011215,1)
		_LEATHER2SMOOTHNESS("LEATHER 2 SMOOTHNESS", Range( 0 , 1)) = 0.3
		[HDR]_LEATHER3COLOR("LEATHER 3 COLOR", Color) = (0.1698113,0.04637412,0.02963688,1)
		_LEATHER3SMOOTHNESS("LEATHER 3 SMOOTHNESS", Range( 0 , 1)) = 0.3
		[HDR]_CLOTH1COLOR("CLOTH 1 COLOR", Color) = (0.1465379,0.282117,0.3490566,0)
		[HDR]_CLOTH2COLOR("CLOTH 2 COLOR", Color) = (1,0,0,0)
		[HDR]_CLOTH3COLOR("CLOTH 3 COLOR", Color) = (0.8773585,0.6337318,0.3434941,0)
		[HDR]_GEMS1COLOR("GEMS 1 COLOR", Color) = (0.3773585,0,0.06650025,0)
		_GEMS1SMOOTHNESS("GEMS 1 SMOOTHNESS", Range( 0 , 1)) = 1
		[HDR]_GEMS2COLOR("GEMS 2 COLOR", Color) = (0.2023368,0,0.4339623,0)
		_GEMS2SMOOTHNESS("GEMS 2 SMOOTHNESS", Range( 0 , 1)) = 0
		[HDR]_GEMS3COLOR("GEMS 3 COLOR", Color) = (0,0.1132075,0.01206957,0)
		_GEMS3SMOOTHNESS("GEMS 3 SMOOTHNESS", Range( 0 , 1)) = 0
		[HDR]_FEATHERS1COLOR("FEATHERS 1 COLOR", Color) = (0.7735849,0.492613,0.492613,0)
		[HDR]_FEATHERS2COLOR("FEATHERS 2 COLOR", Color) = (0.6792453,0,0,0)
		[HDR]_FEATHERS3COLOR("FEATHERS 3 COLOR", Color) = (0,0.1793142,0.7264151,0)
		[HideInInspector]_Texture0("Texture 0", 2D) = "white" {}
		[HideInInspector]_Texture1("Texture 1", 2D) = "white" {}
		[HideInInspector]_Texture6("Texture 6", 2D) = "white" {}
		[HideInInspector]_Texture3("Texture 3", 2D) = "white" {}
		[HideInInspector]_Texture5("Texture 5", 2D) = "white" {}
		[HideInInspector][HDR]_Texture2("Texture 2", 2D) = "white" {}
		[HideInInspector]_Texture4("Texture 4", 2D) = "white" {}
		[HideInInspector]_Texture7("Texture 7", 2D) = "white" {}
		[HDR]_COATOFARMSCOLOR("COAT OF ARMS COLOR", Color) = (1,0,0,0)
		[NoScaleOffset]_COATOFARMSMASK("COAT OF ARMS MASK", 2D) = "black" {}
		_OCCLUSION("OCCLUSION", Range( 0 , 1)) = 0.5
		[Toggle]_MetalicOn("Metalic On", Float) = 1
		[Toggle]_SmoothnessOn("Smoothness On", Float) = 1
		[HideInInspector] _texcoord2( "", 2D ) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1

		// ---- STENCIL (added) ----
		_StencilRef ("Stencil Ref", Range(0,255)) = 1
		[Enum(UnityEngine.Rendering.CompareFunction)] _StencilComp ("Stencil Comp", Float) = 3 // Equal
		// -------------------------
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back

		// ---- STENCIL (added) ----
		Stencil
		{
			Ref [_StencilRef]
			Comp [_StencilComp]
			Pass Keep
			Fail Keep
			ZFail Keep
		}
		// -------------------------

		CGPROGRAM
		#pragma target 3.5
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows exclude_path:deferred 
		struct Input
		{
			float2 uv_texcoord;
			float2 uv2_texcoord2;
		};

		uniform sampler2D _Texture2;
		uniform float4 _Texture2_ST;
		uniform float4 _GEMS3COLOR;
		uniform sampler2D _Texture7;
		uniform float4 _Texture7_ST;
		uniform float4 _GEMS2COLOR;
		uniform float4 _GEMS1COLOR;
		uniform float4 _FEATHERS3COLOR;
		uniform sampler2D _Texture4;
		uniform float4 _Texture4_ST;
		uniform float4 _FEATHERS2COLOR;
		uniform float4 _FEATHERS1COLOR;
		uniform float4 _CLOTH3COLOR;
		uniform sampler2D _Texture5;
		uniform float4 _Texture5_ST;
		uniform float4 _CLOTH2COLOR;
		uniform float4 _CLOTH1COLOR;
		uniform float4 _LEATHER3COLOR;
		uniform sampler2D _Texture3;
		uniform float4 _Texture3_ST;
		uniform float4 _LEATHER2COLOR;
		uniform float4 _LEATHER1COLOR;
		uniform float4 _METAL3COLOR;
		uniform sampler2D _Texture6;
		uniform float4 _Texture6_ST;
		uniform float4 _METAL2COLOR;
		uniform float4 _METAL1COLOR;
		uniform float4 _SCARSCOLOR;
		uniform sampler2D _Texture1;
		uniform float4 _Texture1_ST;
		uniform float4 _LIPSCOLOR;
		uniform float4 _SCLERACOLOR;
		uniform float4 _EYESCOLOR;
		uniform sampler2D _Texture0;
		uniform float4 _Texture0_ST;
		uniform float4 _HAIRCOLOR;
		uniform float4 _SKINCOLOR;
		uniform float4 _COATOFARMSCOLOR;
		uniform sampler2D _COATOFARMSMASK;
		uniform float _MetalicOn;
		uniform float _METAL3METALLIC;
		uniform float _METAL2METALLIC;
		uniform float _METAL1METALLIC;
		uniform float _SmoothnessOn;
		uniform float _GEMS3SMOOTHNESS;
		uniform float _GEMS2SMOOTHNESS;
		uniform float _GEMS1SMOOTHNESS;
		uniform float _LEATHER3SMOOTHNESS;
		uniform float _LEATHER2SMOOTHNESS;
		uniform float _LEATHER1SMOOTHNESS;
		uniform float _METAL3SMOOTHNESS;
		uniform float _METAL2SMOOTHNESS;
		uniform float _METAL1SMOOTHNESS;
		uniform float _SCARSSMOOTHNESS;
		uniform float _LIPSSMOOTHNESS;
		uniform float _SCLERASMOOTHNESS;
		uniform float _EYESSMOOTHNESS;
		uniform float _HAIRSMOOTHNESS;
		uniform float _SKINSMOOTHNESS;
		uniform float _OCCLUSION;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Texture2 = i.uv_texcoord * _Texture2_ST.xy + _Texture2_ST.zw;
			float4 tex2DNode199 = tex2D( _Texture2, uv_Texture2 );
			float2 uv_Texture7 = i.uv_texcoord * _Texture7_ST.xy + _Texture7_ST.zw;
			float4 tex2DNode222 = tex2D( _Texture7, uv_Texture7 );
			float3 temp_cast_0 = (tex2DNode222.b).xxx;
			float temp_output_215_0 = saturate( ( 1.0 - ( ( distance( temp_cast_0 , float3( 0,0,0 ) ) - 0.1 ) / max( 0.0 , 1E-05 ) ) ) );
			float4 lerpResult219 = lerp( float4( 0,0,0,0 ) , ( tex2DNode199 * _GEMS3COLOR ) , temp_output_215_0);
			float3 temp_cast_1 = (tex2DNode222.g).xxx;
			float temp_output_216_0 = saturate( ( 1.0 - ( ( distance( temp_cast_1 , float3( 0,0,0 ) ) - 0.1 ) / max( 0.0 , 1E-05 ) ) ) );
			float4 lerpResult214 = lerp( lerpResult219 , ( tex2DNode199 * _GEMS2COLOR ) , temp_output_216_0);
			float3 temp_cast_2 = (tex2DNode222.r).xxx;
			float temp_output_213_0 = saturate( ( 1.0 - ( ( distance( temp_cast_2 , float3( 0,0,0 ) ) - 0.1 ) / max( 0.0 , 1E-05 ) ) ) );
			float4 lerpResult217 = lerp( lerpResult214 , ( tex2DNode199 * _GEMS1COLOR ) , temp_output_213_0);
			float2 uv_Texture4 = i.uv_texcoord * _Texture4_ST.xy + _Texture4_ST.zw;
			float4 tex2DNode181 = tex2D( _Texture4, uv_Texture4 );
			float3 temp_cast_3 = (tex2DNode181.b).xxx;
			float4 lerpResult182 = lerp( lerpResult217 , ( tex2DNode199 * _FEATHERS3COLOR ) , saturate( ( 1.0 - ( ( distance( temp_cast_3 , float3( 0,0,0 ) ) - 0.1 ) / max( 0.0 , 1E-05 ) ) ) ));
			float3 temp_cast_4 = (tex2DNode181.g).xxx;
			float4 lerpResult189 = lerp( lerpResult182 , ( tex2DNode199 * _FEATHERS2COLOR ) , saturate( ( 1.0 - ( ( distance( temp_cast_4 , float3( 0,0,0 ) ) - 0.1 ) / max( 0.0 , 1E-05 ) ) ) ));
			float3 temp_cast_5 = (tex2DNode181.r).xxx;
			float4 lerpResult184 = lerp( lerpResult189 , ( tex2DNode199 * _FEATHERS1COLOR ) , saturate( ( 1.0 - ( ( distance( temp_cast_5 , float3( 0,0,0 ) ) - 0.1 ) / max( 0.0 , 1E-05 ) ) ) ));
			float2 uv_Texture5 = i.uv_texcoord * _Texture5_ST.xy + _Texture5_ST.zw;
			float4 tex2DNode170 = tex2D( _Texture5, uv_Texture5 );
			float3 temp_cast_6 = (tex2DNode170.b).xxx;
			float4 lerpResult171 = lerp( lerpResult184 , ( tex2DNode199 * _CLOTH3COLOR ) , saturate( ( 1.0 - ( ( distance( temp_cast_6 , float3( 0,0,0 ) ) - 0.1 ) / max( 0.0 , 1E-05 ) ) ) ));
			float3 temp_cast_7 = (tex2DNode170.g).xxx;
			float4 lerpResult178 = lerp( lerpResult171 , ( tex2DNode199 * _CLOTH2COLOR ) , saturate( ( 1.0 - ( ( distance( temp_cast_7 , float3( 0,0,0 ) ) - 0.1 ) / max( 0.0 , 1E-05 ) ) ) ));
			float3 temp_cast_8 = (tex2DNode170.r).xxx;
			float4 lerpResult173 = lerp( lerpResult178 , ( tex2DNode199 * _CLOTH1COLOR ) , saturate( ( 1.0 - ( ( distance( temp_cast_8 , float3( 0,0,0 ) ) - 0.1 ) / max( 0.0 , 1E-05 ) ) ) ));
			float2 uv_Texture3 = i.uv_texcoord * _Texture3_ST.xy + _Texture3_ST.zw;
			float4 tex2DNode159 = tex2D( _Texture3, uv_Texture3 );
			float3 temp_cast_9 = (tex2DNode159.b).xxx;
			float temp_output_165_0 = saturate( ( 1.0 - ( ( distance( temp_cast_9 , float3( 0,0,0 ) ) - 0.1 ) / max( 0.0 , 1E-05 ) ) ) );
			float4 lerpResult160 = lerp( lerpResult173 , ( tex2DNode199 * _LEATHER3COLOR ) , temp_output_165_0);
			float3 temp_cast_10 = (tex2DNode159.g).xxx;
			float temp_output_158_0 = saturate( ( 1.0 - ( ( distance( temp_cast_10 , float3( 0,0,0 ) ) - 0.1 ) / max( 0.0 , 1E-05 ) ) ) );
			float4 lerpResult167 = lerp( lerpResult160 , ( tex2DNode199 * _LEATHER2COLOR ) , temp_output_158_0);
			float3 temp_cast_11 = (tex2DNode159.r).xxx;
			float temp_output_157_0 = saturate( ( 1.0 - ( ( distance( temp_cast_11 , float3( 0,0,0 ) ) - 0.1 ) / max( 0.0 , 1E-05 ) ) ) );
			float4 lerpResult162 = lerp( lerpResult167 , ( tex2DNode199 * _LEATHER1COLOR ) , temp_output_157_0);
			float2 uv_Texture6 = i.uv_texcoord * _Texture6_ST.xy + _Texture6_ST.zw;
			float4 tex2DNode121 = tex2D( _Texture6, uv_Texture6 );
			float3 temp_cast_12 = (tex2DNode121.b).xxx;
			float temp_output_117_0 = saturate( ( 1.0 - ( ( distance( temp_cast_12 , float3( 0,0,0 ) ) - 0.1 ) / max( 0.0 , 1E-05 ) ) ) );
			float4 lerpResult118 = lerp( lerpResult162 , ( tex2DNode199 * _METAL3COLOR ) , temp_output_117_0);
			float3 temp_cast_13 = (tex2DNode121.g).xxx;
			float temp_output_127_0 = saturate( ( 1.0 - ( ( distance( temp_cast_13 , float3( 0,0,0 ) ) - 0.1 ) / max( 0.0 , 1E-05 ) ) ) );
			float4 lerpResult128 = lerp( lerpResult118 , ( tex2DNode199 * _METAL2COLOR ) , temp_output_127_0);
			float3 temp_cast_14 = (tex2DNode121.r).xxx;
			float temp_output_123_0 = saturate( ( 1.0 - ( ( distance( temp_cast_14 , float3( 0,0,0 ) ) - 0.1 ) / max( 0.0 , 1E-05 ) ) ) );
			float4 lerpResult122 = lerp( lerpResult128 , ( tex2DNode199 * _METAL1COLOR ) , temp_output_123_0);
			float2 uv_Texture1 = i.uv_texcoord * _Texture1_ST.xy + _Texture1_ST.zw;
			float4 tex2DNode144 = tex2D( _Texture1, uv_Texture1 );
			float3 temp_cast_15 = (tex2DNode144.b).xxx;
			float temp_output_145_0 = saturate( ( 1.0 - ( ( distance( temp_cast_15 , float3( 0,0,0 ) ) - 0.1 ) / max( 0.0 , 1E-05 ) ) ) );
			float4 lerpResult148 = lerp( lerpResult122 , ( tex2DNode199 * _SCARSCOLOR ) , temp_output_145_0);
			float3 temp_cast_16 = (tex2DNode144.g).xxx;
			float temp_output_149_0 = saturate( ( 1.0 - ( ( distance( temp_cast_16 , float3( 0,0,0 ) ) - 0.1 ) / max( 0.0 , 1E-05 ) ) ) );
			float4 lerpResult151 = lerp( lerpResult148 , ( tex2DNode199 * _LIPSCOLOR ) , temp_output_149_0);
			float3 temp_cast_17 = (tex2DNode144.r).xxx;
			float temp_output_150_0 = saturate( ( 1.0 - ( ( distance( temp_cast_17 , float3( 0,0,0 ) ) - 0.1 ) / max( 0.0 , 1E-05 ) ) ) );
			float4 lerpResult153 = lerp( lerpResult151 , ( tex2DNode199 * _SCLERACOLOR ) , temp_output_150_0);
			float2 uv_Texture0 = i.uv_texcoord * _Texture0_ST.xy + _Texture0_ST.zw;
			float4 tex2DNode37 = tex2D( _Texture0, uv_Texture0 );
			float3 temp_cast_18 = (tex2DNode37.b).xxx;
			float temp_output_71_0 = saturate( ( 1.0 - ( ( distance( temp_cast_18 , float3( 0,0,0 ) ) - 0.1 ) / max( 0.0 , 1E-05 ) ) ) );
			float4 lerpResult73 = lerp( lerpResult153 , ( tex2DNode199 * _EYESCOLOR ) , temp_output_71_0);
			float3 temp_cast_19 = (tex2DNode37.g).xxx;
			float temp_output_67_0 = saturate( ( 1.0 - ( ( distance( temp_cast_19 , float3( 0,0,0 ) ) - 0.1 ) / max( 0.0 , 1E-05 ) ) ) );
			float4 lerpResult69 = lerp( lerpResult73 , ( tex2DNode199 * _HAIRCOLOR ) , temp_output_67_0);
			float3 temp_cast_20 = (tex2DNode37.r).xxx;
			float temp_output_63_0 = saturate( ( 1.0 - ( ( distance( temp_cast_20 , float3( 0,0,0 ) ) - 0.1 ) / max( 0.0 , 1E-05 ) ) ) );
			float4 lerpResult62 = lerp( lerpResult69 , ( tex2DNode199 * _SKINCOLOR ) , temp_output_63_0);
			float2 uv2_COATOFARMSMASK10 = i.uv2_texcoord2;
			float temp_output_9_0 = ( 1.0 - tex2D( _COATOFARMSMASK, uv2_COATOFARMSMASK10 ).a );
			float4 temp_cast_21 = (temp_output_9_0).xxxx;
			float4 temp_output_1_0_g90 = temp_cast_21;
			float4 color25 = IsGammaSpace() ? float4(0,0,0,0) : float4(0,0,0,0);
			float4 temp_output_2_0_g90 = color25;
			float temp_output_11_0_g90 = distance( temp_output_1_0_g90 , temp_output_2_0_g90 );
			float2 _Vector0 = float2(1.6,1);
			float4 lerpResult21_g90 = lerp( _COATOFARMSCOLOR , temp_output_1_0_g90 , saturate( ( ( temp_output_11_0_g90 - _Vector0.x ) / max( _Vector0.y , 1E-05 ) ) ));
			float4 lerpResult64 = lerp( lerpResult62 , lerpResult21_g90 , ( 1.0 - temp_output_9_0 ));
			o.Albedo = lerpResult64.rgb;
			float lerpResult315 = lerp( 0.0 , _METAL3METALLIC , temp_output_117_0);
			float lerpResult319 = lerp( lerpResult315 , _METAL2METALLIC , temp_output_127_0);
			float lerpResult316 = lerp( lerpResult319 , _METAL1METALLIC , temp_output_123_0);
			o.Metallic = (( _MetalicOn )?( lerpResult316 ):( 0.0 ));
			float lerpResult342 = lerp( 0.0 , _GEMS3SMOOTHNESS , temp_output_215_0);
			float lerpResult338 = lerp( lerpResult342 , _GEMS2SMOOTHNESS , temp_output_216_0);
			float lerpResult340 = lerp( lerpResult338 , _GEMS1SMOOTHNESS , temp_output_213_0);
			float lerpResult336 = lerp( lerpResult340 , _LEATHER3SMOOTHNESS , temp_output_165_0);
			float lerpResult332 = lerp( lerpResult336 , _LEATHER2SMOOTHNESS , temp_output_158_0);
			float lerpResult334 = lerp( lerpResult332 , _LEATHER1SMOOTHNESS , temp_output_157_0);
			float lerpResult327 = lerp( lerpResult334 , _METAL3SMOOTHNESS , temp_output_117_0);
			float lerpResult331 = lerp( lerpResult327 , _METAL2SMOOTHNESS , temp_output_127_0);
			float lerpResult328 = lerp( lerpResult331 , _METAL1SMOOTHNESS , temp_output_123_0);
			float lerpResult321 = lerp( lerpResult328 , _SCARSSMOOTHNESS , temp_output_145_0);
			float lerpResult325 = lerp( lerpResult321 , _LIPSSMOOTHNESS , temp_output_149_0);
			float lerpResult322 = lerp( lerpResult325 , _SCLERASMOOTHNESS , temp_output_150_0);
			float lerpResult306 = lerp( lerpResult322 , _EYESSMOOTHNESS , temp_output_71_0);
			float lerpResult304 = lerp( lerpResult306 , _HAIRSMOOTHNESS , temp_output_67_0);
			float lerpResult302 = lerp( lerpResult304 , _SKINSMOOTHNESS , temp_output_63_0);
			o.Smoothness = (( _SmoothnessOn )?( lerpResult302 ):( 0.0 ));
			o.Occlusion = (1.0 + (_OCCLUSION - 0.0) * (0.5 - 1.0) / (1.0 - 0.0));
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
}
