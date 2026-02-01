Shader "Polytope Studio/ PT_Medieval Weapons Shader PBR (Stencil)"
{
	Properties
	{
		[HDR]_METAL1COLOR("METAL 1 COLOR", Color) = (0.7261481,0.7735849,0.7528313,0)
		_METAL1METALLIC("METAL 1 METALLIC", Range( 0 , 1)) = 0.65
		_METAL1SMOOTHNESS("METAL 1 SMOOTHNESS", Range( 0 , 1)) = 0.7
		[HDR]_METAL2COLOR("METAL 2 COLOR", Color) = (1.678431,1.003922,0.1176471,0)
		_METAL2METALLIC("METAL 2 METALLIC", Range( 0 , 1)) = 0.65
		_METAL2SMOOTHNESS("METAL 2 SMOOTHNESS", Range( 0 , 1)) = 0.7
		[HDR]_METAL3COLOR("METAL 3 COLOR", Color) = (0.597023,0.6237553,0.7395956,0)
		_METAL3METALLIC("METAL 3 METALLIC", Range( 0 , 1)) = 0.65
		_METAL3SMOOTHNESS("METAL 3 SMOOTHNESS", Range( 0 , 1)) = 0.7
		[HDR]_METAL4COLOR("METAL 4 COLOR", Color) = (0.8791043,0.8044721,0.9422547,0)
		_METAL4METALLIC("METAL 4 METALLIC", Range( 0 , 1)) = 0.65
		_METAL4SMOOTNESS("METAL 4 SMOOTNESS", Range( 0 , 1)) = 0.7
		[HDR]_WOOD1COLOR("WOOD 1 COLOR", Color) = (0.1981132,0.08345769,0.06261124,0)
		_WOOD1SMOOTHNESS("WOOD 1 SMOOTHNESS", Range( 0 , 1)) = 0.3
		[HDR]_WOOD2COLOR("WOOD 2 COLOR", Color) = (0.1320755,0.06452555,0.05420079,0)
		_WOOD2SMOOTHNESS("WOOD 2 SMOOTHNESS", Range( 0 , 1)) = 0.3
		[HDR]_WOOD3COLOR("WOOD 3 COLOR", Color) = (0.1037736,0.07509367,0.04650232,0)
		_WOOD3SMOOTHNESS("WOOD 3 SMOOTHNESS", Range( 0 , 1)) = 0.3
		[HDR]_LEATHER1COLOR("LEATHER 1 COLOR", Color) = (0.2924528,0.1296404,0.09242612,1)
		_LEATHER1SMOOTHNESS("LEATHER 1 SMOOTHNESS", Range( 0 , 1)) = 0.3
		[HDR]_LEATHER2COLOR("LEATHER 2 COLOR", Color) = (0.06603771,0.03523636,0.03146137,1)
		_LEATHER2SMOOTHNESS("LEATHER 2 SMOOTHNESS", Range( 0 , 1)) = 0.3
		[HDR]_LEATHER3COLOR("LEATHER 3 COLOR", Color) = (0.1320755,0.03139969,0.02180491,1)
		_LEATHER3SMOOTHNESS("LEATHER 3 SMOOTHNESS", Range( 0 , 1)) = 0.3
		[HDR]_PAINT1COLOR("PAINT 1 COLOR", Color) = (0.5450981,0.6936808,0.6980392,0)
		_PAINT1SMOOTHNESS("PAINT 1 SMOOTHNESS", Range( 0 , 1)) = 1
		[HDR]_PAINT2COLOR("PAINT 2 COLOR", Color) = (0.3649431,0.5566038,0.4386422,0)
		_PAINT2SMOOTHNESS("PAINT 2 SMOOTHNESS", Range( 0 , 1)) = 0
		[HDR]_PAINT3COLOR("PAINT 3 COLOR", Color) = (0.5849056,0.5418971,0.4331613,0)
		_PAINT3SMOOTHNESS("PAINT 3 SMOOTHNESS", Range( 0 , 1)) = 0
		[HDR]_GEMS1COLOR("GEMS 1 COLOR", Color) = (1,0,0,0)
		_GEMS1SMOOTHNESS("GEMS 1 SMOOTHNESS", Range( 0 , 1)) = 0.5
		[HDR]_GEMS2COLOR("GEMS 2 COLOR", Color) = (0,0.3218706,0.5754717,0)
		_GEMS2SMOOTHNESS("GEMS 2 SMOOTHNESS", Range( 0 , 1)) = 0.4
		[HDR]_GEMS3COLOR("GEMS 3 COLOR", Color) = (0,0.4716981,0.1359325,0)
		_GEMS3SMOOTHNESS("GEMS 3 SMOOTHNESS", Range( 0 , 1)) = 0.3
		[HDR]_FEATHERS1COLOR("FEATHERS 1 COLOR", Color) = (0.3301887,0.1241556,0.04516733,0)
		[HDR]_FEATHERS2COLOR("FEATHERS 2 COLOR", Color) = (0.509434,0.4260285,0.1802243,0)
		[HDR]_FEATHERS3COLOR("FEATHERS 3 COLOR", Color) = (0.509434,0.25712,0.25712,0)
		[HDR]_FEATHERS4COLOR("FEATHERS 4 COLOR", Color) = (0.8113208,0.2104842,0.2104842,0)
		[HDR]_FEATHERS5COLOR("FEATHERS 5 COLOR", Color) = (0.4150943,0.2615769,0.1468494,0)
		[HDR]_FEATHERS6COLOR("FEATHERS 6 COLOR", Color) = (0.7924528,0.7444169,0.6391954,0)
		[HDR]_COATOFARMSCOLOR("COAT OF ARMS COLOR", Color) = (1,0,0,0)
		[NoScaleOffset]_COATOFARMSMASK("COAT OF ARMS MASK", 2D) = "black" {}
		_OCCLUSION("OCCLUSION", Range( 0 , 1)) = 0.4139509
		[Toggle]_MetalicOn("Metalic On", Float) = 1
		[Toggle]_SmoothnessOn("Smoothness On", Float) = 1
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

		uniform sampler2D _TextureSample2;
		uniform half4 _TextureSample2_ST;
		uniform half4 _PAINT3COLOR;
		uniform sampler2D _TextureSample9;
		uniform half4 _TextureSample9_ST;
		uniform half4 _PAINT2COLOR;
		uniform half4 _PAINT1COLOR;
		uniform half4 _FEATHERS6COLOR;
		uniform half4 _FEATHERS5COLOR;
		uniform half4 _FEATHERS4COLOR;
		uniform half4 _FEATHERS3COLOR;
		uniform half4 _FEATHERS2COLOR;
		uniform half4 _FEATHERS1COLOR;
		uniform half4 _WOOD3COLOR;
		uniform half4 _WOOD2COLOR;
		uniform half4 _WOOD1COLOR;
		uniform half4 _LEATHER3COLOR;
		uniform half4 _LEATHER2COLOR;
		uniform half4 _LEATHER1COLOR;
		uniform half4 _METAL4COLOR;
		uniform half4 _METAL3COLOR;
		uniform half4 _METAL2COLOR;
		uniform half4 _METAL1COLOR;
		uniform half4 _GEMS3COLOR;
		uniform half4 _GEMS2COLOR;
		uniform half4 _GEMS1COLOR;
		uniform half4 _COATOFARMSCOLOR;
		uniform sampler2D _COATOFARMSMASK;
		SamplerState sampler_COATOFARMSMASK;
		uniform half _MetalicOn;
		uniform half _METAL4METALLIC;
		uniform half _METAL3METALLIC;
		uniform half _METAL2METALLIC;
		uniform half _METAL1METALLIC;
		uniform half _SmoothnessOn;
		uniform half _PAINT3SMOOTHNESS;
		uniform half _PAINT2SMOOTHNESS;
		uniform half _PAINT1SMOOTHNESS;
		uniform half _WOOD3SMOOTHNESS;
		uniform half _WOOD2SMOOTHNESS;
		uniform half _WOOD1SMOOTHNESS;
		uniform half _LEATHER3SMOOTHNESS;
		uniform half _LEATHER2SMOOTHNESS;
		uniform half _LEATHER1SMOOTHNESS;
		uniform half _METAL4SMOOTNESS;
		uniform half _METAL3SMOOTHNESS;
		uniform half _METAL2SMOOTHNESS;
		uniform half _METAL1SMOOTHNESS;
		uniform half _GEMS3SMOOTHNESS;
		uniform half _GEMS2SMOOTHNESS;
		uniform half _GEMS1SMOOTHNESS;
		uniform half _OCCLUSION;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_TextureSample2 = i.uv_texcoord * _TextureSample2_ST.xy + _TextureSample2_ST.zw;
			half4 tex2DNode199 = tex2D( _TextureSample2, uv_TextureSample2 );
			half4 color684 = IsGammaSpace() ? half4(1,0.4980392,0.4980392,1) : half4(1,0.2122307,0.2122307,1);
			float2 uv_TextureSample9 = i.uv_texcoord * _TextureSample9_ST.xy + _TextureSample9_ST.zw;
			half4 tex2DNode647 = tex2D( _TextureSample9, uv_TextureSample9 );
			half temp_output_686_0 = saturate( ( 1.0 - ( ( distance( color684.rgb , tex2DNode647.rgb ) - 0.1 ) / max( 0.0 , 1E-05 ) ) ) );
			half4 lerpResult219 = lerp( float4( 0,0,0,0 ) , ( tex2DNode199 * _PAINT3COLOR ) , temp_output_686_0);
			half4 color687 = IsGammaSpace() ? half4(0.4980392,0.4980392,0.4980392,1) : half4(0.2122307,0.2122307,0.2122307,1);
			half temp_output_683_0 = saturate( ( 1.0 - ( ( distance( color687.rgb , tex2DNode647.rgb ) - 0.1 ) / max( 0.0 , 1E-05 ) ) ) );
			half4 lerpResult214 = lerp( lerpResult219 , ( tex2DNode199 * _PAINT2COLOR ) , temp_output_683_0);
			half4 color688 = IsGammaSpace() ? half4(0.4980392,0.4980392,0,1) : half4(0.2122307,0.2122307,0,1);
			half temp_output_685_0 = saturate( ( 1.0 - ( ( distance( color688.rgb , tex2DNode647.rgb ) - 0.1 ) / max( 0.0 , 1E-05 ) ) ) );
			half4 lerpResult217 = lerp( lerpResult214 , ( tex2DNode199 * _PAINT1COLOR ) , temp_output_685_0);
			half4 color665 = IsGammaSpace() ? half4(0,0.4980392,0,1) : half4(0,0.2122307,0,1);
			half4 lerpResult182 = lerp( lerpResult217 , ( tex2DNode199 * _FEATHERS6COLOR ) , saturate( ( 1.0 - ( ( distance( color665.rgb , tex2DNode647.rgb ) - 0.1 ) / max( 0.0 , 1E-05 ) ) ) ));
			half4 color670 = IsGammaSpace() ? half4(0,0,0,1) : half4(0,0,0,1);
			half4 lerpResult189 = lerp( lerpResult182 , ( tex2DNode199 * _FEATHERS5COLOR ) , saturate( ( 1.0 - ( ( distance( color670.rgb , tex2DNode647.rgb ) - 0.0 ) / max( 0.0 , 1E-05 ) ) ) ));
			half4 color714 = IsGammaSpace() ? half4(1,1,0,1) : half4(1,1,0,1);
			half4 lerpResult184 = lerp( lerpResult189 , ( tex2DNode199 * _FEATHERS4COLOR ) , saturate( ( 1.0 - ( ( distance( color714.rgb , tex2DNode647.rgb ) - 0.0 ) / max( 0.0 , 1E-05 ) ) ) ));
			half4 color719 = IsGammaSpace() ? half4(0.4980392,0,0,1) : half4(0.2122307,0,0,1);
			half4 lerpResult700 = lerp( lerpResult184 , ( tex2DNode199 * _FEATHERS3COLOR ) , saturate( ( 1.0 - ( ( distance( color719.rgb , tex2DNode647.rgb ) - 0.1 ) / max( 0.0 , 1E-05 ) ) ) ));
			half4 color717 = IsGammaSpace() ? half4(1,0.4980392,0,1) : half4(1,0.2122307,0,1);
			half4 lerpResult701 = lerp( lerpResult700 , ( tex2DNode199 * _FEATHERS2COLOR ) , saturate( ( 1.0 - ( ( distance( color717.rgb , tex2DNode647.rgb ) - 0.1 ) / max( 0.0 , 1E-05 ) ) ) ));
			half4 color715 = IsGammaSpace() ? half4(1,0,0,1) : half4(1,0,0,1);
			half4 lerpResult703 = lerp( lerpResult701 , ( tex2DNode199 * _FEATHERS1COLOR ) , saturate( ( 1.0 - ( ( distance( color715.rgb , tex2DNode647.rgb ) - 0.0 ) / max( 0.0 , 1E-05 ) ) ) ));
			half4 color660 = IsGammaSpace() ? half4(0,0,1,0) : half4(0,0,1,0);
			half temp_output_659_0 = saturate( ( 1.0 - ( ( distance( color660.rgb , tex2DNode647.rgb ) - 0.0 ) / max( 0.0 , 1E-05 ) ) ) );
			half4 lerpResult171 = lerp( lerpResult703 , ( tex2DNode199 * _WOOD3COLOR ) , temp_output_659_0);
			half4 color664 = IsGammaSpace() ? half4(0,1,1,1) : half4(0,1,1,1);
			half temp_output_663_0 = saturate( ( 1.0 - ( ( distance( color664.rgb , tex2DNode647.rgb ) - 0.0 ) / max( 0.0 , 1E-05 ) ) ) );
			half4 lerpResult178 = lerp( lerpResult171 , ( tex2DNode199 * _WOOD2COLOR ) , temp_output_663_0);
			half4 color668 = IsGammaSpace() ? half4(0,1,0,1) : half4(0,1,0,1);
			half temp_output_667_0 = saturate( ( 1.0 - ( ( distance( color668.rgb , tex2DNode647.rgb ) - 0.0 ) / max( 0.0 , 1E-05 ) ) ) );
			half4 lerpResult173 = lerp( lerpResult178 , ( tex2DNode199 * _WOOD1COLOR ) , temp_output_667_0);
			half4 color671 = IsGammaSpace() ? half4(1,0.4980392,1,1) : half4(1,0.2122307,1,1);
			half temp_output_672_0 = saturate( ( 1.0 - ( ( distance( color671.rgb , tex2DNode647.rgb ) - 0.1 ) / max( 0.0 , 1E-05 ) ) ) );
			half4 lerpResult160 = lerp( lerpResult173 , ( tex2DNode199 * _LEATHER3COLOR ) , temp_output_672_0);
			half4 color674 = IsGammaSpace() ? half4(1,0,1,1) : half4(1,0,1,1);
			half temp_output_673_0 = saturate( ( 1.0 - ( ( distance( color674.rgb , tex2DNode647.rgb ) - 0.0 ) / max( 0.0 , 1E-05 ) ) ) );
			half4 lerpResult167 = lerp( lerpResult160 , ( tex2DNode199 * _LEATHER2COLOR ) , temp_output_673_0);
			half4 color676 = IsGammaSpace() ? half4(1,1,0.4980392,1) : half4(1,1,0.2122307,1);
			half temp_output_675_0 = saturate( ( 1.0 - ( ( distance( color676.rgb , tex2DNode647.rgb ) - 0.1 ) / max( 0.0 , 1E-05 ) ) ) );
			half4 lerpResult162 = lerp( lerpResult167 , ( tex2DNode199 * _LEATHER1COLOR ) , temp_output_675_0);
			half4 color680 = IsGammaSpace() ? half4(0.4980392,0.4980392,1,1) : half4(0.2122307,0.2122307,1,1);
			half temp_output_679_0 = saturate( ( 1.0 - ( ( distance( color680.rgb , tex2DNode647.rgb ) - 0.1 ) / max( 0.0 , 1E-05 ) ) ) );
			half4 lerpResult727 = lerp( lerpResult162 , ( tex2DNode199 * _METAL4COLOR ) , temp_output_679_0);
			half4 color693 = IsGammaSpace() ? half4(0,0.4980392,0.4980392,1) : half4(0,0.2122307,0.2122307,1);
			half temp_output_694_0 = saturate( ( 1.0 - ( ( distance( color693.rgb , tex2DNode647.rgb ) - 0.1 ) / max( 0.0 , 1E-05 ) ) ) );
			half4 lerpResult118 = lerp( lerpResult727 , ( tex2DNode199 * _METAL3COLOR ) , temp_output_694_0);
			half4 color681 = IsGammaSpace() ? half4(0,0,0.4980392,1) : half4(0,0,0.2122307,1);
			half temp_output_678_0 = saturate( ( 1.0 - ( ( distance( color681.rgb , tex2DNode647.rgb ) - 0.1 ) / max( 0.0 , 1E-05 ) ) ) );
			half4 lerpResult128 = lerp( lerpResult118 , ( tex2DNode199 * _METAL2COLOR ) , temp_output_678_0);
			half4 color682 = IsGammaSpace() ? half4(0.4980392,0,0.4980392,1) : half4(0.2122307,0,0.2122307,1);
			half temp_output_677_0 = saturate( ( 1.0 - ( ( distance( color682.rgb , tex2DNode647.rgb ) - 0.1 ) / max( 0.0 , 1E-05 ) ) ) );
			half4 lerpResult122 = lerp( lerpResult128 , ( tex2DNode199 * _METAL1COLOR ) , temp_output_677_0);
			half4 color689 = IsGammaSpace() ? half4(0.4980392,1,1,1) : half4(0.2122307,1,1,1);
			half temp_output_690_0 = saturate( ( 1.0 - ( ( distance( color689.rgb , tex2DNode647.rgb ) - 0.1 ) / max( 0.0 , 1E-05 ) ) ) );
			half4 lerpResult148 = lerp( lerpResult122 , ( tex2DNode199 * _GEMS3COLOR ) , temp_output_690_0);
			half4 color729 = IsGammaSpace() ? half4(0.4980392,1,0.4980392,1) : half4(0.2122307,1,0.2122307,1);
			half temp_output_728_0 = saturate( ( 1.0 - ( ( distance( color729.rgb , tex2DNode647.rgb ) - 0.1 ) / max( 0.0 , 1E-05 ) ) ) );
			half4 lerpResult151 = lerp( lerpResult148 , ( tex2DNode199 * _GEMS2COLOR ) , temp_output_728_0);
			half4 color661 = IsGammaSpace() ? half4(0.4980392,0,1,1) : half4(0.2122307,0,1,1);
			half temp_output_662_0 = saturate( ( 1.0 - ( ( distance( color661.rgb , tex2DNode647.rgb ) - 0.1 ) / max( 0.0 , 1E-05 ) ) ) );
			half4 lerpResult153 = lerp( lerpResult151 , ( tex2DNode199 * _GEMS1COLOR ) , temp_output_662_0);
			float2 uv2_COATOFARMSMASK10 = i.uv2_texcoord2;
			half temp_output_9_0 = ( 1.0 - tex2D( _COATOFARMSMASK, uv2_COATOFARMSMASK10 ).a );
			half4 temp_cast_44 = (temp_output_9_0).xxxx;
			half4 temp_output_1_0_g153 = temp_cast_44;
			half4 color25 = IsGammaSpace() ? half4(0,0,0,0) : half4(0,0,0,0);
			half4 temp_output_2_0_g153 = color25;
			half temp_output_11_0_g153 = distance( temp_output_1_0_g153 , temp_output_2_0_g153 );
			half2 _Vector0 = half2(1.6,1);
			half4 lerpResult21_g153 = lerp( _COATOFARMSCOLOR , temp_output_1_0_g153 , saturate( ( ( temp_output_11_0_g153 - _Vector0.x ) / max( _Vector0.y , 1E-05 ) ) ));
			half temp_output_16_0 = ( 1.0 - temp_output_9_0 );
			half4 lerpResult64 = lerp( lerpResult153 , lerpResult21_g153 , temp_output_16_0);
			o.Albedo = lerpResult64.rgb;
			half lerpResult723 = lerp( 0.0 , _METAL4METALLIC , temp_output_679_0);
			half lerpResult315 = lerp( lerpResult723 , _METAL3METALLIC , temp_output_694_0);
			half lerpResult319 = lerp( lerpResult315 , _METAL2METALLIC , temp_output_678_0);
			half lerpResult316 = lerp( lerpResult319 , _METAL1METALLIC , temp_output_677_0);
			half lerpResult734 = lerp( lerpResult316 , 0.0 , temp_output_16_0);
			o.Metallic = (( _MetalicOn )?( lerpResult734 ):( 0.0 ));
			half lerpResult342 = lerp( 0.0 , _PAINT3SMOOTHNESS , temp_output_686_0);
			half lerpResult338 = lerp( lerpResult342 , _PAINT2SMOOTHNESS , temp_output_683_0);
			half lerpResult340 = lerp( lerpResult338 , _PAINT1SMOOTHNESS , temp_output_685_0);
			half lerpResult707 = lerp( lerpResult340 , _WOOD3SMOOTHNESS , temp_output_659_0);
			half lerpResult708 = lerp( lerpResult707 , _WOOD2SMOOTHNESS , temp_output_663_0);
			half lerpResult710 = lerp( lerpResult708 , _WOOD1SMOOTHNESS , temp_output_667_0);
			half lerpResult336 = lerp( lerpResult710 , _LEATHER3SMOOTHNESS , temp_output_672_0);
			half lerpResult332 = lerp( lerpResult336 , _LEATHER2SMOOTHNESS , temp_output_673_0);
			half lerpResult334 = lerp( lerpResult332 , _LEATHER1SMOOTHNESS , temp_output_675_0);
			half lerpResult722 = lerp( lerpResult334 , _METAL4SMOOTNESS , temp_output_679_0);
			half lerpResult327 = lerp( lerpResult722 , _METAL3SMOOTHNESS , temp_output_694_0);
			half lerpResult331 = lerp( lerpResult327 , _METAL2SMOOTHNESS , temp_output_678_0);
			half lerpResult328 = lerp( lerpResult331 , _METAL1SMOOTHNESS , temp_output_677_0);
			half lerpResult321 = lerp( lerpResult328 , _GEMS3SMOOTHNESS , temp_output_690_0);
			half lerpResult325 = lerp( lerpResult321 , _GEMS2SMOOTHNESS , temp_output_728_0);
			half lerpResult322 = lerp( lerpResult325 , _GEMS1SMOOTHNESS , temp_output_662_0);
			o.Smoothness = (( _SmoothnessOn )?( lerpResult322 ):( 0.0 ));
			o.Occlusion = (1.0 + (_OCCLUSION - 0.0) * (0.5 - 1.0) / (1.0 - 0.0));
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
