Shader "Polytope Studio/ PT_Medieval Armors Shader Toon (Stencil)"
{
	Properties
	{
		[HDR]_SKINCOLOR("SKIN COLOR", Color) = (0.6792453,0.4017712,0.3300107,1)
		[HDR]_EYESCOLOR("EYES COLOR", Color) = (0.02723388,0.1132075,0.02941043,0)
		[HDR]_HAIRCOLOR("HAIR COLOR", Color) = (0.2924528,0.152883,0.03448736,0)
		[HDR]_SCLERACOLOR("SCLERA COLOR", Color) = (0.9056604,0.8159487,0.8159487,0)
		[HDR]_LIPSCOLOR("LIPS COLOR", Color) = (0.8301887,0.3185886,0.2780349,0)
		[HDR]_SCARSCOLOR("SCARS COLOR", Color) = (0.8490566,0.5037117,0.3884835,0)
		[HDR]_METAL1COLOR("METAL 1 COLOR", Color) = (0.8117647,0.3651657,0,0)
		[HDR]_METAL2COLOR("METAL 2 COLOR", Color) = (0.2768779,0.3082185,0.3207547,0)
		[HDR]_METAL3COLOR("METAL 3 COLOR", Color) = (0.04565683,0.04565683,0.05660379,0)
		[HDR]_LEATHER1COLOR("LEATHER 1 COLOR", Color) = (0.5,0.3367247,0.1438679,0)
		[HDR]_LEATHER2COLOR("LEATHER 2 COLOR", Color) = (0.2264151,0.1746179,0.1591314,0)
		[HDR]_LEATHER3COLOR("LEATHER 3 COLOR", Color) = (0.3207547,0.196269,0.1376825,0)
		[HDR]_CLOTH1COLOR("CLOTH 1 COLOR", Color) = (0.1465379,0.282117,0.3490566,0)
		[HDR]_CLOTH2COLOR("CLOTH 2 COLOR", Color) = (0.6226415,0,0,0)
		[HDR]_CLOTH3COLOR("CLOTH 3 COLOR", Color) = (0.4339623,0.3827875,0.3827875,0)
		[HDR]_GEMS1COLOR("GEMS 1 COLOR", Color) = (0.3773585,0,0.06650025,0)
		[HDR]_GEMS2COLOR("GEMS 2 COLOR", Color) = (0.2023368,0,0.4339623,0)
		[HDR]_GEMS3COLOR("GEMS 3 COLOR", Color) = (0,0.1132075,0.01206957,0)
		[HDR]_FEATHERS1COLOR("FEATHERS 1 COLOR", Color) = (0.7735849,0.492613,0.492613,0)
		[HDR]_FEATHERS2COLOR("FEATHERS 2 COLOR", Color) = (0.6792453,0,0,0)
		[HDR]_FEATHERS3COLOR("FEATHERS 3 COLOR", Color) = (0,0.1793142,0.7264151,0)
		[HideInInspector]_Texture0("Texture 0", 2D) = "white" {}
		[HideInInspector]_Texture1("Texture 1", 2D) = "white" {}
		[HideInInspector]_Texture6("Texture 6", 2D) = "white" {}
		[HideInInspector]_Texture3("Texture 3", 2D) = "white" {}
		[HideInInspector]_Texture5("Texture 5", 2D) = "white" {}
		[HideInInspector]_Texture2("Texture 2", 2D) = "white" {}
		[HideInInspector]_Texture4("Texture 4", 2D) = "white" {}
		[HideInInspector]_Texture7("Texture 7", 2D) = "white" {}
		[HDR]_COATOFARMSCOLOR("COAT OF ARMS COLOR", Color) = (1,0,0,0)
		[NoScaleOffset]_COATOFARMSMASK("COAT OF ARMS MASK", 2D) = "black" {}
		_LIGHT1SIZE("LIGHT 1 SIZE", Range( 0 , 1)) = 0.1
		_LIGHT2SIZE("LIGHT 2 SIZE", Range( 0 , 1)) = 0.4
		_LIGHT3SIZE("LIGHT 3 SIZE", Range( 0 , 1)) = 0.8
		_LIGHT1POWER("LIGHT 1 POWER", Range( 0 , 1)) = 0.15
		_LIGHT2POWER("LIGHT 2 POWER", Range( 0 , 1)) = 0.15
		_LIGHT3POWER("LIGHT 3 POWER", Range( 0 , 1)) = 0.15
		[HDR]_LIGHT1COLOR("LIGHT 1 COLOR", Color) = (1,1,1,0)
		[HDR]_LIGHT2COLOR("LIGHT 2 COLOR", Color) = (1,1,1,0)
		[HDR]_LIGHT3COLOR("LIGHT 3 COLOR", Color) = (1,1,1,0)
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
		uniform float _LIGHT1SIZE;
		uniform float4 _LIGHT1COLOR;
		uniform float _LIGHT1POWER;
		uniform float _LIGHT2SIZE;
		uniform float4 _LIGHT2COLOR;
		uniform float _LIGHT2POWER;
		uniform float _LIGHT3SIZE;
		uniform float4 _LIGHT3COLOR;
		uniform float _LIGHT3POWER;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 uv_Texture2 = i.uv_texcoord * _Texture2_ST.xy + _Texture2_ST.zw;
			float4 tex2DNode199 = tex2D( _Texture2, uv_Texture2 );
			float2 uv_Texture7 = i.uv_texcoord * _Texture7_ST.xy + _Texture7_ST.zw;
			float4 tex2DNode222 = tex2D( _Texture7, uv_Texture7 );
			float3 temp_cast_0 = (tex2DNode222.b).xxx;
			float4 lerpResult219 = lerp( float4( 0,0,0,0 ) , ( tex2DNode199 * _GEMS3COLOR ) , saturate( ( 1.0 - ( ( distance( temp_cast_0 , float3( 0,0,0 ) ) - 0.1 ) / max( 0.0 , 1E-05 ) ) ) ));
			float3 temp_cast_1 = (tex2DNode222.g).xxx;
			float4 lerpResult214 = lerp( lerpResult219 , ( tex2DNode199 * _GEMS2COLOR ) , saturate( ( 1.0 - ( ( distance( temp_cast_1 , float3( 0,0,0 ) ) - 0.1 ) / max( 0.0 , 1E-05 ) ) ) ));
			float3 temp_cast_2 = (tex2DNode222.r).xxx;
			float4 lerpResult217 = lerp( lerpResult214 , ( tex2DNode199 * _GEMS1COLOR ) , saturate( ( 1.0 - ( ( distance( temp_cast_2 , float3( 0,0,0 ) ) - 0.1 ) / max( 0.0 , 1E-05 ) ) ) ));
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
			float4 lerpResult160 = lerp( lerpResult173 , ( tex2DNode199 * _LEATHER3COLOR ) , saturate( ( 1.0 - ( ( distance( temp_cast_9 , float3( 0,0,0 ) ) - 0.1 ) / max( 0.0 , 1E-05 ) ) ) ));
			float3 temp_cast_10 = (tex2DNode159.g).xxx;
			float4 lerpResult167 = lerp( lerpResult160 , ( tex2DNode199 * _LEATHER2COLOR ) , saturate( ( 1.0 - ( ( distance( temp_cast_10 , float3( 0,0,0 ) ) - 0.1 ) / max( 0.0 , 1E-05 ) ) ) ));
			float3 temp_cast_11 = (tex2DNode159.r).xxx;
			float4 lerpResult162 = lerp( lerpResult167 , ( tex2DNode199 * _LEATHER1COLOR ) , saturate( ( 1.0 - ( ( distance( temp_cast_11 , float3( 0,0,0 ) ) - 0.1 ) / max( 0.0 , 1E-05 ) ) ) ));
			float2 uv_Texture6 = i.uv_texcoord * _Texture6_ST.xy + _Texture6_ST.zw;
			float4 tex2DNode121 = tex2D( _Texture6, uv_Texture6 );
			float3 temp_cast_12 = (tex2DNode121.b).xxx;
			float4 lerpResult118 = lerp( lerpResult162 , ( tex2DNode199 * _METAL3COLOR ) , saturate( ( 1.0 - ( ( distance( float3( 0,0,0 ) , temp_cast_12 ) - 0.1 ) / max( 0.0 , 1E-05 ) ) ) ));
			float3 temp_cast_13 = (tex2DNode121.g).xxx;
			float4 lerpResult128 = lerp( lerpResult118 , ( tex2DNode199 * _METAL2COLOR ) , saturate( ( 1.0 - ( ( distance( temp_cast_13 , float3( 0,0,0 ) ) - 0.1 ) / max( 0.0 , 1E-05 ) ) ) ));
			float3 temp_cast_14 = (tex2DNode121.r).xxx;
			float4 lerpResult122 = lerp( lerpResult128 , ( tex2DNode199 * _METAL1COLOR ) , saturate( ( 1.0 - ( ( distance( temp_cast_14 , float3( 0,0,0 ) ) - 0.1 ) / max( 0.0 , 1E-05 ) ) ) ));
			float2 uv_Texture1 = i.uv_texcoord * _Texture1_ST.xy + _Texture1_ST.zw;
			float4 tex2DNode144 = tex2D( _Texture1, uv_Texture1 );
			float3 temp_cast_15 = (tex2DNode144.b).xxx;
			float4 lerpResult148 = lerp( lerpResult122 , ( tex2DNode199 * _SCARSCOLOR ) , saturate( ( 1.0 - ( ( distance( temp_cast_15 , float3( 0,0,0 ) ) - 0.1 ) / max( 0.0 , 1E-05 ) ) ) ));
			float3 temp_cast_16 = (tex2DNode144.g).xxx;
			float4 lerpResult151 = lerp( lerpResult148 , ( tex2DNode199 * _LIPSCOLOR ) , saturate( ( 1.0 - ( ( distance( temp_cast_16 , float3( 0,0,0 ) ) - 0.1 ) / max( 0.0 , 1E-05 ) ) ) ));
			float3 temp_cast_17 = (tex2DNode144.r).xxx;
			float4 lerpResult153 = lerp( lerpResult151 , ( tex2DNode199 * _SCLERACOLOR ) , saturate( ( 1.0 - ( ( distance( temp_cast_17 , float3( 0,0,0 ) ) - 0.1 ) / max( 0.0 , 1E-05 ) ) ) ));
			float2 uv_Texture0 = i.uv_texcoord * _Texture0_ST.xy + _Texture0_ST.zw;
			float4 tex2DNode37 = tex2D( _Texture0, uv_Texture0 );
			float3 temp_cast_18 = (tex2DNode37.b).xxx;
			float4 lerpResult73 = lerp( lerpResult153 , ( tex2DNode199 * _EYESCOLOR ) , saturate( ( 1.0 - ( ( distance( temp_cast_18 , float3( 0,0,0 ) ) - 0.1 ) / max( 0.0 , 1E-05 ) ) ) ));
			float3 temp_cast_19 = (tex2DNode37.g).xxx;
			float4 lerpResult69 = lerp( lerpResult73 , ( tex2DNode199 * _HAIRCOLOR ) , saturate( ( 1.0 - ( ( distance( temp_cast_19 , float3( 0,0,0 ) ) - 0.1 ) / max( 0.0 , 1E-05 ) ) ) ));
			float3 temp_cast_20 = (tex2DNode37.r).xxx;
			float4 lerpResult62 = lerp( lerpResult69 , ( tex2DNode199 * _SKINCOLOR ) , saturate( ( 1.0 - ( ( distance( float3( 0,0,0 ) , temp_cast_20 ) - 0.1 ) / max( 0.0 , 1E-05 ) ) ) ));
			float2 uv2_COATOFARMSMASK10 = i.uv2_texcoord2;
			float temp_output_9_0 = ( 1.0 - tex2D( _COATOFARMSMASK, uv2_COATOFARMSMASK10 ).a );
			float4 temp_cast_21 = (temp_output_9_0).xxxx;
			float4 temp_output_1_0_g81 = temp_cast_21;
			float4 color25 = IsGammaSpace() ? float4(0,0,0,0) : float4(0,0,0,0);
			float4 temp_output_2_0_g81 = color25;
			float temp_output_11_0_g81 = distance( temp_output_1_0_g81 , temp_output_2_0_g81 );
			float2 _Vector0 = float2(1.6,1);
			float4 lerpResult21_g81 = lerp( _COATOFARMSCOLOR , temp_output_1_0_g81 , saturate( ( ( temp_output_11_0_g81 - _Vector0.x ) / max( _Vector0.y , 1E-05 ) ) ));
			float4 lerpResult64 = lerp( lerpResult62 , lerpResult21_g81 , ( 1.0 - temp_output_9_0 ));
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = i.worldNormal;
			float fresnelNdotV369 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode369 = ( 0.0 + 1.0 * pow( max( 1.0 - fresnelNdotV369 , 0.0001 ), 1.0 ) );
			float4 temp_cast_22 = (step( fresnelNode369 , _LIGHT1SIZE )).xxxx;
			float4 blendOpSrc689 = temp_cast_22;
			float4 blendOpDest689 = _LIGHT1COLOR;
			float4 temp_cast_23 = ((0.0 + (_LIGHT1POWER - 0.0) * (3.0 - 0.0) / (1.0 - 0.0))).xxxx;
			float4 blendOpSrc683 = ( saturate( ( blendOpSrc689 * blendOpDest689 ) ));
			float4 blendOpDest683 = temp_cast_23;
			float4 blendOpSrc661 = ( blendOpSrc683 * blendOpDest683 );
			float4 blendOpDest661 = lerpResult64;
			float fresnelNdotV365 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode365 = ( 0.0 + 1.0 * pow( 1.0 - fresnelNdotV365, 1.0 ) );
			float4 temp_cast_24 = (step( fresnelNode365 , _LIGHT2SIZE )).xxxx;
			float4 blendOpSrc696 = temp_cast_24;
			float4 blendOpDest696 = _LIGHT2COLOR;
			float4 temp_cast_25 = ((0.0 + (_LIGHT2POWER - 0.0) * (3.0 - 0.0) / (1.0 - 0.0))).xxxx;
			float4 blendOpSrc686 = ( saturate( ( blendOpSrc696 * blendOpDest696 ) ));
			float4 blendOpDest686 = temp_cast_25;
			float4 blendOpSrc662 = ( blendOpSrc686 * blendOpDest686 );
			float4 blendOpDest662 = lerpResult64;
			float fresnelNdotV368 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode368 = ( 0.0 + 1.0 * pow( 1.0 - fresnelNdotV368, 1.0 ) );
			float4 temp_cast_26 = (step( fresnelNode368 , _LIGHT3SIZE )).xxxx;
			float4 blendOpSrc698 = temp_cast_26;
			float4 blendOpDest698 = _LIGHT3COLOR;
			float4 temp_cast_27 = ((0.0 + (_LIGHT3POWER - 0.0) * (3.0 - 0.0) / (1.0 - 0.0))).xxxx;
			float4 blendOpSrc687 = ( saturate( ( blendOpSrc698 * blendOpDest698 ) ));
			float4 blendOpDest687 = temp_cast_27;
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
