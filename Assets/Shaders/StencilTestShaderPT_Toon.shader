Shader "Polytope Studio/ PT_Medieval Modular NPC Shader Toon (Stencil)"
{
	Properties
	{
		[HDR]_SKINCOLOR1("SKIN COLOR", Color) = (2.02193,1.0081,0.6199315,0)
		[HDR]_COATOFARMSCOLOR("COAT OF ARMS COLOR", Color) = (1,0,0,0)
		[NoScaleOffset]_COATOFARMSMASK("COAT OF ARMS MASK", 2D) = "black" {}
		_CEL1SIZE("CEL 1 SIZE", Range( 0 , 1)) = 0.1
		[HDR]_EYESCOLOR1("EYES COLOR", Color) = (0.0734529,0.1320755,0.05046281,1)
		_CEL2SIZE("CEL 2 SIZE", Range( 0 , 1)) = 0.4
		_CEL3SIZE("CEL 3 SIZE", Range( 0 , 1)) = 0.8
		[HDR]_HAIRCOLOR1("HAIR COLOR", Color) = (1,0,0,0)
		_CEL1POWER("CEL 1 POWER", Range( 0 , 1)) = 0.15
		_CEL2POWER("CEL 2 POWER", Range( 0 , 1)) = 0.15
		[HDR]_SCLERACOLOR1("SCLERA COLOR", Color) = (0.9056604,0.8159487,0.8159487,0)
		_CEL3POWER("CEL 3 POWER", Range( 0 , 1)) = 0.15
		[HDR]_CEL1COLOR("CEL 1 COLOR", Color) = (1,1,1,0)
		[HDR]_LIPSCOLOR1("LIPS COLOR", Color) = (0.8301887,0.3185886,0.2780349,0)
		[HDR]_CEL2COLOR("CEL 2 COLOR", Color) = (1,1,1,0)
		[HDR]_OTHERCOLOR1("OTHER COLOR", Color) = (0.5188679,0.4637216,0.3206212,0)
		[HDR]_CEL3COLOR("CEL 3 COLOR", Color) = (1,1,1,0)
		[HDR]_METAL1COLOR1("METAL 1 COLOR", Color) = (0.8792791,0.9922886,1.007606,0)
		[HDR]_METAL2COLOR1("METAL 2 COLOR", Color) = (0.4674706,0.4677705,0.5188679,0)
		[HDR]_METAL3COLOR1("METAL 3 COLOR", Color) = (0.4383232,0.4383232,0.4716981,0)
		[HDR]_METAL4COLOR1("METAL 4 COLOR", Color) = (0.4383232,0.4383232,0.4716981,0)
		[HDR]_LEATHER1COLOR1("LEATHER 1 COLOR", Color) = (0.4811321,0.2041155,0.08851016,1)
		[HDR]_LEATHER2COLOR1("LEATHER 2 COLOR", Color) = (0.4245283,0.190437,0.09011215,1)
		[HDR]_LEATHER3COLOR1("LEATHER 3 COLOR", Color) = (0.1698113,0.04637412,0.02963688,1)
		[HDR]_LEATHER4COLOR1("LEATHER 4 COLOR", Color) = (0.1698113,0.04637412,0.02963688,1)
		[HDR]_CLOTH1COLOR1("CLOTH 1 COLOR", Color) = (0,0.1792453,0.05062231,0)
		[HDR]_CLOTH2COLOR1("CLOTH 2 COLOR", Color) = (1,0,0,0)
		[HDR]_CLOTH3COLOR1("CLOTH 3 COLOR", Color) = (0.3962264,0.3391397,0.2710039,0)
		[HDR]_CLOTH4COLOR1("CLOTH 4 COLOR", Color) = (0.2011392,0.3773585,0.3739074,0)
		[HDR]_FEATHERS1COLOR1("FEATHERS 1 COLOR", Color) = (0.7735849,0.492613,0.492613,0)
		[HDR]_FEATHERS2COLOR1("FEATHERS 2 COLOR", Color) = (0.6792453,0,0,0)
		[HideInInspector]_TextureSample1("Texture Sample 0", 2D) = "white" {}
		[HideInInspector]_TextureSample3("Texture Sample 2", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] _texcoord2( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1

		// ---- STENCIL (added) ----
		_StencilRef ("Stencil Ref", Range(0,255)) = 1
		[Enum(UnityEngine.Rendering.CompareFunction)] _StencilComp ("Stencil Comp", Float) = 3 // Equal
		// -------------------------
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
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

		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float2 uv_texcoord;
			float2 uv2_texcoord2;
			float3 worldPos;
			float3 worldNormal;
		};

		uniform sampler2D _TextureSample3;
		uniform float4 _TextureSample3_ST;
		uniform float4 _FEATHERS2COLOR1;
		uniform sampler2D _TextureSample1;
		uniform float4 _TextureSample1_ST;
		uniform float4 _FEATHERS1COLOR1;
		uniform float4 _CLOTH4COLOR1;
		uniform float4 _CLOTH3COLOR1;
		uniform float4 _CLOTH2COLOR1;
		uniform float4 _CLOTH1COLOR1;
		uniform float4 _LEATHER4COLOR1;
		uniform float4 _LEATHER3COLOR1;
		uniform float4 _LEATHER2COLOR1;
		uniform float4 _LEATHER1COLOR1;
		uniform float4 _METAL4COLOR1;
		uniform float4 _METAL3COLOR1;
		uniform float4 _METAL2COLOR1;
		uniform float4 _METAL1COLOR1;
		uniform float4 _OTHERCOLOR1;
		uniform float4 _LIPSCOLOR1;
		uniform float4 _SCLERACOLOR1;
		uniform float4 _EYESCOLOR1;
		uniform float4 _HAIRCOLOR1;
		uniform float4 _SKINCOLOR1;
		uniform float4 _COATOFARMSCOLOR;
		uniform sampler2D _COATOFARMSMASK;
		uniform float _CEL1SIZE;
		uniform float4 _CEL1COLOR;
		uniform float _CEL1POWER;
		uniform float _CEL2SIZE;
		uniform float4 _CEL2COLOR;
		uniform float _CEL2POWER;
		uniform float _CEL3SIZE;
		uniform float4 _CEL3COLOR;
		uniform float _CEL3POWER;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 uv_TextureSample3 = i.uv_texcoord * _TextureSample3_ST.xy + _TextureSample3_ST.zw;
			float4 tex2DNode722 = tex2D( _TextureSample3, uv_TextureSample3 );
			float4 color721 = IsGammaSpace() ? float4(0.4980392,1,1,1) : float4(0.2122307,1,1,1);
			float2 uv_TextureSample1 = i.uv_texcoord * _TextureSample1_ST.xy + _TextureSample1_ST.zw;
			float4 tex2DNode724 = tex2D( _TextureSample1, uv_TextureSample1 );
			float4 lerpResult729 = lerp( float4( 0,0,0,0 ) , ( tex2DNode722 * _FEATHERS2COLOR1 ) , saturate( ( 1.0 - ( ( distance( color721.rgb , tex2DNode724.rgb ) - 0.1 ) / max( 0.0 , 1E-05 ) ) ) ));
			float4 color728 = IsGammaSpace() ? float4(0.4980392,1,0.4980392,1) : float4(0.2122307,1,0.2122307,1);
			float4 lerpResult737 = lerp( lerpResult729 , ( tex2DNode722 * _FEATHERS1COLOR1 ) , saturate( ( 1.0 - ( ( distance( color728.rgb , tex2DNode724.rgb ) - 0.1 ) / max( 0.0 , 1E-05 ) ) ) ));
			float4 color732 = IsGammaSpace() ? float4(0,0,1,1) : float4(0,0,1,1);
			float4 lerpResult745 = lerp( lerpResult737 , ( tex2DNode722 * _CLOTH4COLOR1 ) , saturate( ( 1.0 - ( ( distance( color732.rgb , tex2DNode724.rgb ) - 0.1 ) / max( 0.0 , 1E-05 ) ) ) ));
			float4 color734 = IsGammaSpace() ? float4(0,1,1,1) : float4(0,1,1,1);
			float4 lerpResult750 = lerp( lerpResult745 , ( tex2DNode722 * _CLOTH3COLOR1 ) , saturate( ( 1.0 - ( ( distance( color734.rgb , tex2DNode724.rgb ) - 0.1 ) / max( 0.0 , 1E-05 ) ) ) ));
			float4 color741 = IsGammaSpace() ? float4(0,1,0,1) : float4(0,1,0,1);
			float4 lerpResult754 = lerp( lerpResult750 , ( tex2DNode722 * _CLOTH2COLOR1 ) , saturate( ( 1.0 - ( ( distance( color741.rgb , tex2DNode724.rgb ) - 0.1 ) / max( 0.0 , 1E-05 ) ) ) ));
			float4 color748 = IsGammaSpace() ? float4(0,0.4980392,0,1) : float4(0,0.2122307,0,1);
			float4 lerpResult761 = lerp( lerpResult754 , ( tex2DNode722 * _CLOTH1COLOR1 ) , saturate( ( 1.0 - ( ( distance( color748.rgb , tex2DNode724.rgb ) - 0.1 ) / max( 0.0 , 1E-05 ) ) ) ));
			float4 color735 = IsGammaSpace() ? float4(1,0.4980392,0.4980392,1) : float4(1,0.2122307,0.2122307,1);
			float4 lerpResult766 = lerp( lerpResult761 , ( tex2DNode722 * _LEATHER4COLOR1 ) , saturate( ( 1.0 - ( ( distance( color735.rgb , tex2DNode724.rgb ) - 0.1 ) / max( 0.0 , 1E-05 ) ) ) ));
			float4 color746 = IsGammaSpace() ? float4(1,1,0.4980392,1) : float4(1,1,0.2122307,1);
			float4 lerpResult771 = lerp( lerpResult766 , ( tex2DNode722 * _LEATHER3COLOR1 ) , saturate( ( 1.0 - ( ( distance( color746.rgb , tex2DNode724.rgb ) - 0.1 ) / max( 0.0 , 1E-05 ) ) ) ));
			float4 color753 = IsGammaSpace() ? float4(1,0,1,1) : float4(1,0,1,1);
			float4 lerpResult776 = lerp( lerpResult771 , ( tex2DNode722 * _LEATHER2COLOR1 ) , saturate( ( 1.0 - ( ( distance( color753.rgb , tex2DNode724.rgb ) - 0.1 ) / max( 0.0 , 1E-05 ) ) ) ));
			float4 color755 = IsGammaSpace() ? float4(1,0.4980392,1,1) : float4(1,0.2122307,1,1);
			float4 lerpResult782 = lerp( lerpResult776 , ( tex2DNode722 * _LEATHER1COLOR1 ) , saturate( ( 1.0 - ( ( distance( color755.rgb , tex2DNode724.rgb ) - 0.1 ) / max( 0.0 , 1E-05 ) ) ) ));
			float4 color762 = IsGammaSpace() ? float4(0.4980392,0.4980392,1,1) : float4(0.2122307,0.2122307,1,1);
			float4 lerpResult788 = lerp( lerpResult782 , ( tex2DNode722 * _METAL4COLOR1 ) , saturate( ( 1.0 - ( ( distance( color762.rgb , tex2DNode724.rgb ) - 0.1 ) / max( 0.0 , 1E-05 ) ) ) ));
			float4 color769 = IsGammaSpace() ? float4(0,0.4980392,0.4980392,1) : float4(0,0.2122307,0.2122307,1);
			float4 lerpResult794 = lerp( lerpResult788 , ( tex2DNode722 * _METAL3COLOR1 ) , saturate( ( 1.0 - ( ( distance( color769.rgb , tex2DNode724.rgb ) - 0.1 ) / max( 0.0 , 1E-05 ) ) ) ));
			float4 color770 = IsGammaSpace() ? float4(0,0,0.4980392,1) : float4(0,0,0.2122307,1);
			float4 lerpResult799 = lerp( lerpResult794 , ( tex2DNode722 * _METAL2COLOR1 ) , saturate( ( 1.0 - ( ( distance( color770.rgb , tex2DNode724.rgb ) - 0.1 ) / max( 0.0 , 1E-05 ) ) ) ));
			float4 color778 = IsGammaSpace() ? float4(0.4980392,0,0.4980392,1) : float4(0.2122307,0,0.2122307,1);
			float4 lerpResult803 = lerp( lerpResult799 , ( tex2DNode722 * _METAL1COLOR1 ) , saturate( ( 1.0 - ( ( distance( color778.rgb , tex2DNode724.rgb ) - 0.1 ) / max( 0.0 , 1E-05 ) ) ) ));
			float4 color784 = IsGammaSpace() ? float4(1,1,0,1) : float4(1,1,0,1);
			float4 lerpResult807 = lerp( lerpResult803 , ( tex2DNode722 * _OTHERCOLOR1 ) , saturate( ( 1.0 - ( ( distance( color784.rgb , tex2DNode724.rgb ) - 0.1 ) / max( 0.0 , 1E-05 ) ) ) ));
			float4 color786 = IsGammaSpace() ? float4(0.4980392,0.4980392,0,1) : float4(0.2122307,0.2122307,0,1);
			float4 lerpResult811 = lerp( lerpResult807 , ( tex2DNode722 * _LIPSCOLOR1 ) , saturate( ( 1.0 - ( ( distance( color786.rgb , tex2DNode724.rgb ) - 0.1 ) / max( 0.0 , 1E-05 ) ) ) ));
			float4 color792 = IsGammaSpace() ? float4(0.4980392,0.4980392,0.4980392,1) : float4(0.2122307,0.2122307,0.2122307,1);
			float4 lerpResult815 = lerp( lerpResult811 , ( tex2DNode722 * _SCLERACOLOR1 ) , saturate( ( 1.0 - ( ( distance( color792.rgb , tex2DNode724.rgb ) - 0.1 ) / max( 0.0 , 1E-05 ) ) ) ));
			float4 color790 = IsGammaSpace() ? float4(1,0,0,1) : float4(1,0,0,1);
			float4 lerpResult820 = lerp( lerpResult815 , ( tex2DNode722 * _EYESCOLOR1 ) , saturate( ( 1.0 - ( ( distance( color790.rgb , tex2DNode724.rgb ) - 0.1 ) / max( 0.0 , 1E-05 ) ) ) ));
			float4 color804 = IsGammaSpace() ? float4(1,0.4980392,0,1) : float4(1,0.2122307,0,1);
			float4 lerpResult821 = lerp( lerpResult820 , ( tex2DNode722 * _HAIRCOLOR1 ) , saturate( ( 1.0 - ( ( distance( color804.rgb , tex2DNode724.rgb ) - 0.1 ) / max( 0.0 , 1E-05 ) ) ) ));
			float4 color806 = IsGammaSpace() ? float4(0.4980392,0,0,1) : float4(0.2122307,0,0,1);
			float4 lerpResult823 = lerp( lerpResult821 , ( tex2DNode722 * _SKINCOLOR1 ) , saturate( ( 1.0 - ( ( distance( color806.rgb , tex2DNode724.rgb ) - 0.1 ) / max( 0.0 , 1E-05 ) ) ) ));
			float2 uv1_COATOFARMSMASK10 = i.uv2_texcoord2;
			float temp_output_9_0 = ( 1.0 - tex2D( _COATOFARMSMASK, uv1_COATOFARMSMASK10 ).a );
			float4 temp_cast_40 = (temp_output_9_0).xxxx;
			float4 temp_output_1_0_g139 = temp_cast_40;
			float4 color25 = IsGammaSpace() ? float4(0,0,0,0) : float4(0,0,0,0);
			float4 temp_output_2_0_g139 = color25;
			float temp_output_11_0_g139 = distance( temp_output_1_0_g139 , temp_output_2_0_g139 );
			float2 _Vector0 = float2(1.6,1);
			float4 lerpResult21_g139 = lerp( _COATOFARMSCOLOR , temp_output_1_0_g139 , saturate( ( ( temp_output_11_0_g139 - _Vector0.x ) / max( _Vector0.y , 1E-05 ) ) ));
			float4 lerpResult64 = lerp( lerpResult823 , lerpResult21_g139 , ( 1.0 - temp_output_9_0 ));
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = i.worldNormal;
			float fresnelNdotV369 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode369 = ( 0.0 + 1.0 * pow( max( 1.0 - fresnelNdotV369 , 0.0001 ), 1.0 ) );
			float4 temp_cast_41 = (step( fresnelNode369 , _CEL1SIZE )).xxxx;
			float4 blendOpSrc689 = temp_cast_41;
			float4 blendOpDest689 = _CEL1COLOR;
			float4 temp_cast_42 = ((0.0 + (_CEL1POWER - 0.0) * (3.0 - 0.0) / (1.0 - 0.0))).xxxx;
			float4 blendOpSrc683 = ( saturate( ( blendOpSrc689 * blendOpDest689 ) ));
			float4 blendOpDest683 = temp_cast_42;
			float4 blendOpSrc661 = ( blendOpSrc683 * blendOpDest683 );
			float4 blendOpDest661 = lerpResult64;
			float fresnelNdotV365 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode365 = ( 0.0 + 1.0 * pow( 1.0 - fresnelNdotV365, 1.0 ) );
			float4 temp_cast_43 = (step( fresnelNode365 , _CEL2SIZE )).xxxx;
			float4 blendOpSrc696 = temp_cast_43;
			float4 blendOpDest696 = _CEL2COLOR;
			float4 temp_cast_44 = ((0.0 + (_CEL2POWER - 0.0) * (3.0 - 0.0) / (1.0 - 0.0))).xxxx;
			float4 blendOpSrc686 = ( saturate( ( blendOpSrc696 * blendOpDest696 ) ));
			float4 blendOpDest686 = temp_cast_44;
			float4 blendOpSrc662 = ( blendOpSrc686 * blendOpDest686 );
			float4 blendOpDest662 = lerpResult64;
			float fresnelNdotV368 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode368 = ( 0.0 + 1.0 * pow( 1.0 - fresnelNdotV368, 1.0 ) );
			float4 temp_cast_45 = (step( fresnelNode368 , _CEL3SIZE )).xxxx;
			float4 blendOpSrc698 = temp_cast_45;
			float4 blendOpDest698 = _CEL3COLOR;
			float4 temp_cast_46 = ((0.0 + (_CEL3POWER - 0.0) * (3.0 - 0.0) / (1.0 - 0.0))).xxxx;
			float4 blendOpSrc687 = ( saturate( ( blendOpSrc698 * blendOpDest698 ) ));
			float4 blendOpDest687 = temp_cast_46;
			float4 blendOpSrc663 = ( blendOpSrc687 * blendOpDest687 );
			float4 blendOpDest663 = lerpResult64;
			o.Emission = ( lerpResult64 + ( ( blendOpSrc661 * blendOpDest661 ) + ( saturate( ( blendOpSrc662 * blendOpDest662 ) )) + ( saturate( ( blendOpSrc663 * blendOpDest663 ) )) ) ).rgb;
			o.Alpha = 1;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Unlit keepalpha fullforwardshadows exclude_path:deferred 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float4 customPack1 : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
				float3 worldNormal : TEXCOORD3;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.worldNormal = worldNormal;
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.customPack1.zw = customInputData.uv2_texcoord2;
				o.customPack1.zw = v.texcoord1;
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				surfIN.uv2_texcoord2 = IN.customPack1.zw;
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = IN.worldNormal;
				SurfaceOutput o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutput, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
}
