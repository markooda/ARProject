Shader "Polytope Studio/ PT_Medieval Weapons Shader Toon (Stencil)"
{
	Properties
	{
		[HDR]_COATOFARMSCOLOR("COAT OF ARMS COLOR", Color) = (1,0,0,0)
		[HDR]_METAL1COLOR("METAL 1 COLOR", Color) = (0.7261481,0.7735849,0.7528313,0)
		[NoScaleOffset]_COATOFARMSMASK("COAT OF ARMS MASK", 2D) = "black" {}
		_CEL1SIZE("CEL 1 SIZE", Range( 0 , 1)) = 0.1
		_CEL2SIZE("CEL 2 SIZE", Range( 0 , 1)) = 0.4
		[HDR]_METAL2COLOR("METAL 2 COLOR", Color) = (1.678431,1.003922,0.1176471,0)
		_CEL3SIZE("CEL 3 SIZE", Range( 0 , 1)) = 0.8
		_CEL1POWER("CEL 1 POWER", Range( 0 , 1)) = 0.15
		_CEL2POWER("CEL 2 POWER", Range( 0 , 1)) = 0.15
		[HDR]_METAL3COLOR("METAL 3 COLOR", Color) = (0.597023,0.6237553,0.7395956,0)
		_CEL3POWER("CEL 3 POWER", Range( 0 , 1)) = 0.15
		[HDR]_CEL1COLOR("CEL 1 COLOR", Color) = (1,1,1,0)
		[HDR]_CEL2COLOR("CEL 2 COLOR", Color) = (1,1,1,0)
		[HDR]_METAL4COLOR("METAL 4 COLOR", Color) = (0.8791043,0.8044721,0.9422547,0)
		[HDR]_CEL3COLOR("CEL 3 COLOR", Color) = (1,1,1,0)
		[HDR]_WOOD1COLOR("WOOD 1 COLOR", Color) = (0.1981132,0.08345769,0.06261124,0)
		[HDR]_WOOD2COLOR("WOOD 2 COLOR", Color) = (0.1320755,0.06452555,0.05420079,0)
		[HDR]_WOOD3COLOR("WOOD 3 COLOR", Color) = (0.1037736,0.07509367,0.04650232,0)
		[HDR]_LEATHER1COLOR("LEATHER 1 COLOR", Color) = (0.2924528,0.1296404,0.09242612,1)
		[HDR]_LEATHER2COLOR("LEATHER 2 COLOR", Color) = (0.06603771,0.03523636,0.03146137,1)
		[HDR]_LEATHER3COLOR("LEATHER 3 COLOR", Color) = (0.1320755,0.03139969,0.02180491,1)
		[HDR]_PAINT1COLOR("PAINT 1 COLOR", Color) = (0.5450981,0.6936808,0.6980392,0)
		[HDR]_PAINT2COLOR("PAINT 2 COLOR", Color) = (0.3649431,0.5566038,0.4386422,0)
		[HDR]_PAINT3COLOR("PAINT 3 COLOR", Color) = (0.5849056,0.5418971,0.4331613,0)
		[HDR]_GEMS1COLOR("GEMS 1 COLOR", Color) = (1,0,0,0)
		[HDR]_GEMS2COLOR("GEMS 2 COLOR", Color) = (0,0.3218706,0.5754717,0)
		[HDR]_GEMS3COLOR("GEMS 3 COLOR", Color) = (0,0.4716981,0.1359325,0)
		[HDR]_FEATHERS1COLOR("FEATHERS 1 COLOR", Color) = (0.3301887,0.1241556,0.04516733,0)
		[HDR]_FEATHERS2COLOR("FEATHERS 2 COLOR", Color) = (0.509434,0.4260285,0.1802243,0)
		[HDR]_FEATHERS3COLOR("FEATHERS 3 COLOR", Color) = (0.509434,0.25712,0.25712,0)
		[HDR]_FEATHERS4COLOR("FEATHERS 4 COLOR", Color) = (0.8113208,0.2104842,0.2104842,0)
		[HDR]_FEATHERS5COLOR("FEATHERS 5 COLOR", Color) = (0.4150943,0.2615769,0.1468494,0)
		[HDR]_FEATHERS6COLOR("FEATHERS 6 COLOR", Color) = (0.7924528,0.7444169,0.6391954,0)
		[HideInInspector]_TextureSample2("Texture Sample 2", 2D) = "white" {}
		[HideInInspector]_TextureSample9("Texture Sample 9", 2D) = "white" {}
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

		uniform sampler2D _TextureSample2;
		uniform float4 _TextureSample2_ST;
		uniform float4 _PAINT3COLOR;
		uniform sampler2D _TextureSample9;
		uniform float4 _TextureSample9_ST;
		uniform float4 _PAINT2COLOR;
		uniform float4 _PAINT1COLOR;
		uniform float4 _FEATHERS6COLOR;
		uniform float4 _FEATHERS5COLOR;
		uniform float4 _FEATHERS4COLOR;
		uniform float4 _FEATHERS3COLOR;
		uniform float4 _FEATHERS2COLOR;
		uniform float4 _FEATHERS1COLOR;
		uniform float4 _WOOD3COLOR;
		uniform float4 _WOOD2COLOR;
		uniform float4 _WOOD1COLOR;
		uniform float4 _LEATHER3COLOR;
		uniform float4 _LEATHER2COLOR;
		uniform float4 _LEATHER1COLOR;
		uniform float4 _METAL4COLOR;
		uniform float4 _METAL3COLOR;
		uniform float4 _METAL2COLOR;
		uniform float4 _METAL1COLOR;
		uniform float4 _GEMS3COLOR;
		uniform float4 _GEMS2COLOR;
		uniform float4 _GEMS1COLOR;
		uniform float4 _COATOFARMSCOLOR;
		uniform sampler2D _COATOFARMSMASK;
		SamplerState sampler_COATOFARMSMASK;
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
			float2 uv_TextureSample2 = i.uv_texcoord * _TextureSample2_ST.xy + _TextureSample2_ST.zw;
			float4 tex2DNode717 = tex2D( _TextureSample2, uv_TextureSample2 );
			float4 color719 = IsGammaSpace() ? float4(1,0.4980392,0.4980392,1) : float4(1,0.2122307,0.2122307,1);
			float2 uv_TextureSample9 = i.uv_texcoord * _TextureSample9_ST.xy + _TextureSample9_ST.zw;
			float4 tex2DNode718 = tex2D( _TextureSample9, uv_TextureSample9 );
			float4 lerpResult729 = lerp( float4( 0,0,0,0 ) , ( tex2DNode717 * _PAINT3COLOR ) , saturate( ( 1.0 - ( ( distance( color719.rgb , tex2DNode718.rgb ) - 0.1 ) / max( 0.0 , 1E-05 ) ) ) ));
			float4 color720 = IsGammaSpace() ? float4(0.4980392,0.4980392,0.4980392,1) : float4(0.2122307,0.2122307,0.2122307,1);
			float4 lerpResult731 = lerp( lerpResult729 , ( tex2DNode717 * _PAINT2COLOR ) , saturate( ( 1.0 - ( ( distance( color720.rgb , tex2DNode718.rgb ) - 0.1 ) / max( 0.0 , 1E-05 ) ) ) ));
			float4 color724 = IsGammaSpace() ? float4(0.4980392,0.4980392,0,1) : float4(0.2122307,0.2122307,0,1);
			float4 lerpResult738 = lerp( lerpResult731 , ( tex2DNode717 * _PAINT1COLOR ) , saturate( ( 1.0 - ( ( distance( color724.rgb , tex2DNode718.rgb ) - 0.1 ) / max( 0.0 , 1E-05 ) ) ) ));
			float4 color734 = IsGammaSpace() ? float4(0,0.4980392,0,1) : float4(0,0.2122307,0,1);
			float4 lerpResult741 = lerp( lerpResult738 , ( tex2DNode717 * _FEATHERS6COLOR ) , saturate( ( 1.0 - ( ( distance( color734.rgb , tex2DNode718.rgb ) - 0.1 ) / max( 0.0 , 1E-05 ) ) ) ));
			float4 color737 = IsGammaSpace() ? float4(0,0,0,1) : float4(0,0,0,1);
			float4 lerpResult746 = lerp( lerpResult741 , ( tex2DNode717 * _FEATHERS5COLOR ) , saturate( ( 1.0 - ( ( distance( color737.rgb , tex2DNode718.rgb ) - 0.0 ) / max( 0.0 , 1E-05 ) ) ) ));
			float4 color744 = IsGammaSpace() ? float4(1,1,0,1) : float4(1,1,0,1);
			float4 lerpResult752 = lerp( lerpResult746 , ( tex2DNode717 * _FEATHERS4COLOR ) , saturate( ( 1.0 - ( ( distance( color744.rgb , tex2DNode718.rgb ) - 0.0 ) / max( 0.0 , 1E-05 ) ) ) ));
			float4 color745 = IsGammaSpace() ? float4(0.4980392,0,0,1) : float4(0.2122307,0,0,1);
			float4 lerpResult758 = lerp( lerpResult752 , ( tex2DNode717 * _FEATHERS3COLOR ) , saturate( ( 1.0 - ( ( distance( color745.rgb , tex2DNode718.rgb ) - 0.1 ) / max( 0.0 , 1E-05 ) ) ) ));
			float4 color753 = IsGammaSpace() ? float4(1,0.4980392,0,1) : float4(1,0.2122307,0,1);
			float4 lerpResult761 = lerp( lerpResult758 , ( tex2DNode717 * _FEATHERS2COLOR ) , saturate( ( 1.0 - ( ( distance( color753.rgb , tex2DNode718.rgb ) - 0.1 ) / max( 0.0 , 1E-05 ) ) ) ));
			float4 color757 = IsGammaSpace() ? float4(1,0,0,1) : float4(1,0,0,1);
			float4 lerpResult767 = lerp( lerpResult761 , ( tex2DNode717 * _FEATHERS1COLOR ) , saturate( ( 1.0 - ( ( distance( color757.rgb , tex2DNode718.rgb ) - 0.0 ) / max( 0.0 , 1E-05 ) ) ) ));
			float4 color762 = IsGammaSpace() ? float4(0,0,1,0) : float4(0,0,1,0);
			float4 lerpResult772 = lerp( lerpResult767 , ( tex2DNode717 * _WOOD3COLOR ) , saturate( ( 1.0 - ( ( distance( color762.rgb , tex2DNode718.rgb ) - 0.0 ) / max( 0.0 , 1E-05 ) ) ) ));
			float4 color769 = IsGammaSpace() ? float4(0,1,1,1) : float4(0,1,1,1);
			float4 lerpResult779 = lerp( lerpResult772 , ( tex2DNode717 * _WOOD2COLOR ) , saturate( ( 1.0 - ( ( distance( color769.rgb , tex2DNode718.rgb ) - 0.0 ) / max( 0.0 , 1E-05 ) ) ) ));
			float4 color771 = IsGammaSpace() ? float4(0,1,0,1) : float4(0,1,0,1);
			float4 lerpResult785 = lerp( lerpResult779 , ( tex2DNode717 * _WOOD1COLOR ) , saturate( ( 1.0 - ( ( distance( color771.rgb , tex2DNode718.rgb ) - 0.0 ) / max( 0.0 , 1E-05 ) ) ) ));
			float4 color781 = IsGammaSpace() ? float4(1,0.4980392,1,1) : float4(1,0.2122307,1,1);
			float4 lerpResult788 = lerp( lerpResult785 , ( tex2DNode717 * _LEATHER3COLOR ) , saturate( ( 1.0 - ( ( distance( color781.rgb , tex2DNode718.rgb ) - 0.1 ) / max( 0.0 , 1E-05 ) ) ) ));
			float4 color782 = IsGammaSpace() ? float4(1,0,1,1) : float4(1,0,1,1);
			float4 lerpResult794 = lerp( lerpResult788 , ( tex2DNode717 * _LEATHER2COLOR ) , saturate( ( 1.0 - ( ( distance( color782.rgb , tex2DNode718.rgb ) - 0.0 ) / max( 0.0 , 1E-05 ) ) ) ));
			float4 color789 = IsGammaSpace() ? float4(1,1,0.4980392,1) : float4(1,1,0.2122307,1);
			float4 lerpResult801 = lerp( lerpResult794 , ( tex2DNode717 * _LEATHER1COLOR ) , saturate( ( 1.0 - ( ( distance( color789.rgb , tex2DNode718.rgb ) - 0.1 ) / max( 0.0 , 1E-05 ) ) ) ));
			float4 color797 = IsGammaSpace() ? float4(0.4980392,0.4980392,1,1) : float4(0.2122307,0.2122307,1,1);
			float4 lerpResult804 = lerp( lerpResult801 , ( tex2DNode717 * _METAL4COLOR ) , saturate( ( 1.0 - ( ( distance( color797.rgb , tex2DNode718.rgb ) - 0.1 ) / max( 0.0 , 1E-05 ) ) ) ));
			float4 color799 = IsGammaSpace() ? float4(0,0.4980392,0.4980392,1) : float4(0,0.2122307,0.2122307,1);
			float4 lerpResult810 = lerp( lerpResult804 , ( tex2DNode717 * _METAL3COLOR ) , saturate( ( 1.0 - ( ( distance( color799.rgb , tex2DNode718.rgb ) - 0.1 ) / max( 0.0 , 1E-05 ) ) ) ));
			float4 color806 = IsGammaSpace() ? float4(0,0,0.4980392,1) : float4(0,0,0.2122307,1);
			float4 lerpResult814 = lerp( lerpResult810 , ( tex2DNode717 * _METAL2COLOR ) , saturate( ( 1.0 - ( ( distance( color806.rgb , tex2DNode718.rgb ) - 0.1 ) / max( 0.0 , 1E-05 ) ) ) ));
			float4 color808 = IsGammaSpace() ? float4(0.4980392,0,0.4980392,1) : float4(0.2122307,0,0.2122307,1);
			float4 lerpResult821 = lerp( lerpResult814 , ( tex2DNode717 * _METAL1COLOR ) , saturate( ( 1.0 - ( ( distance( color808.rgb , tex2DNode718.rgb ) - 0.1 ) / max( 0.0 , 1E-05 ) ) ) ));
			float4 color815 = IsGammaSpace() ? float4(0.4980392,1,1,1) : float4(0.2122307,1,1,1);
			float4 lerpResult824 = lerp( lerpResult821 , ( tex2DNode717 * _GEMS3COLOR ) , saturate( ( 1.0 - ( ( distance( color815.rgb , tex2DNode718.rgb ) - 0.1 ) / max( 0.0 , 1E-05 ) ) ) ));
			float4 color822 = IsGammaSpace() ? float4(0.4980392,1,0.4980392,1) : float4(0.2122307,1,0.2122307,1);
			float4 lerpResult830 = lerp( lerpResult824 , ( tex2DNode717 * _GEMS2COLOR ) , saturate( ( 1.0 - ( ( distance( color822.rgb , tex2DNode718.rgb ) - 0.1 ) / max( 0.0 , 1E-05 ) ) ) ));
			float4 color825 = IsGammaSpace() ? float4(0.4980392,0,1,1) : float4(0.2122307,0,1,1);
			float4 lerpResult832 = lerp( lerpResult830 , ( tex2DNode717 * _GEMS1COLOR ) , saturate( ( 1.0 - ( ( distance( color825.rgb , tex2DNode718.rgb ) - 0.1 ) / max( 0.0 , 1E-05 ) ) ) ));
			float2 uv2_COATOFARMSMASK10 = i.uv2_texcoord2;
			float temp_output_9_0 = ( 1.0 - tex2D( _COATOFARMSMASK, uv2_COATOFARMSMASK10 ).a );
			float4 temp_cast_44 = (temp_output_9_0).xxxx;
			float4 temp_output_1_0_g170 = temp_cast_44;
			float4 color25 = IsGammaSpace() ? float4(0,0,0,0) : float4(0,0,0,0);
			float4 temp_output_2_0_g170 = color25;
			float temp_output_11_0_g170 = distance( temp_output_1_0_g170 , temp_output_2_0_g170 );
			float2 _Vector0 = float2(1.6,1);
			float4 lerpResult21_g170 = lerp( _COATOFARMSCOLOR , temp_output_1_0_g170 , saturate( ( ( temp_output_11_0_g170 - _Vector0.x ) / max( _Vector0.y , 1E-05 ) ) ));
			float4 lerpResult64 = lerp( lerpResult832 , lerpResult21_g170 , ( 1.0 - temp_output_9_0 ));
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = i.worldNormal;
			float fresnelNdotV369 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode369 = ( 0.0 + 1.0 * pow( max( 1.0 - fresnelNdotV369 , 0.0001 ), 1.0 ) );
			float4 temp_cast_45 = (step( fresnelNode369 , _CEL1SIZE )).xxxx;
			float4 blendOpSrc689 = temp_cast_45;
			float4 blendOpDest689 = _CEL1COLOR;
			float4 temp_cast_46 = ((0.0 + (_CEL1POWER - 0.0) * (3.0 - 0.0) / (1.0 - 0.0))).xxxx;
			float4 blendOpSrc683 = ( saturate( ( blendOpSrc689 * blendOpDest689 ) ));
			float4 blendOpDest683 = temp_cast_46;
			float4 blendOpSrc661 = ( blendOpSrc683 * blendOpDest683 );
			float4 blendOpDest661 = lerpResult64;
			float fresnelNdotV365 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode365 = ( 0.0 + 1.0 * pow( 1.0 - fresnelNdotV365, 1.0 ) );
			float4 temp_cast_47 = (step( fresnelNode365 , _CEL2SIZE )).xxxx;
			float4 blendOpSrc696 = temp_cast_47;
			float4 blendOpDest696 = _CEL2COLOR;
			float4 temp_cast_48 = ((0.0 + (_CEL2POWER - 0.0) * (3.0 - 0.0) / (1.0 - 0.0))).xxxx;
			float4 blendOpSrc686 = ( saturate( ( blendOpSrc696 * blendOpDest696 ) ));
			float4 blendOpDest686 = temp_cast_48;
			float4 blendOpSrc662 = ( blendOpSrc686 * blendOpDest686 );
			float4 blendOpDest662 = lerpResult64;
			float fresnelNdotV368 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode368 = ( 0.0 + 1.0 * pow( 1.0 - fresnelNdotV368, 1.0 ) );
			float4 temp_cast_49 = (step( fresnelNode368 , _CEL3SIZE )).xxxx;
			float4 blendOpSrc698 = temp_cast_49;
			float4 blendOpDest698 = _CEL3COLOR;
			float4 temp_cast_50 = ((0.0 + (_CEL3POWER - 0.0) * (3.0 - 0.0) / (1.0 - 0.0))).xxxx;
			float4 blendOpSrc687 = ( saturate( ( blendOpSrc698 * blendOpDest698 ) ));
			float4 blendOpDest687 = temp_cast_50;
			float4 blendOpSrc663 = ( blendOpSrc687 * blendOpDest687 );
			float4 blendOpDest663 = lerpResult64;
			o.Emission = ( lerpResult64 + ( ( blendOpSrc661 * blendOpDest661 ) + ( saturate( ( blendOpSrc662 * blendOpDest662 ) )) + ( saturate( ( blendOpSrc663 * blendOpDest663 ) )) ) ).rgb;
			o.Alpha = 1;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Unlit keepalpha fullforwardshadows 

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
	CustomEditor "ASEMaterialInspector"
}
