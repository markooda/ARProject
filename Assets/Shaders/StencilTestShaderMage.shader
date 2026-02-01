Shader "Feyloom_Built-in/Base Shader Built-in (Stencil)"
{
    Properties
    {
        [Header(____COLOR____)]_ChangeBaseColor("ChangeBaseColor", Color) = (1,1,1,0)
        [Header(____ROUGHNESS____)]_Base_Roughness("Base_Roughness", Range( 0 , 1)) = 0
        [Header(____TEXTURES____)][NoScaleOffset]_BaseColor_1("BaseColor_1", 2D) = "white" {}
        [NoScaleOffset]_Normal("Normal", 2D) = "white" {}
        [HideInInspector] _texcoord( "", 2D ) = "white" {}
        [HideInInspector] __dirty( "", Int ) = 1

        // ---- STENCIL (added) ----
        _StencilRef ("Stencil Ref", Range(0,255)) = 1
        [Enum(UnityEngine.Rendering.CompareFunction)] _StencilComp ("Stencil Comp", Float) = 3 // Equal
        // -------------------------
    }

    SubShader
    {
        Tags{ "RenderType" = "Opaque"  "Queue" = "AlphaTest+0" }
        Cull Off
        AlphaToMask On

        // ---- STENCIL (added) ----
        // Applies to the surface shader generated passes.
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
        #pragma target 4.6
        struct Input
        {
            float2 uv_texcoord;
        };

        uniform sampler2D _Normal;
        uniform sampler2D _BaseColor_1;
        uniform float4 _ChangeBaseColor;
        uniform float _Base_Roughness;

        void surf( Input i , inout SurfaceOutputStandard o )
        {
            float2 uv_Normal48 = i.uv_texcoord;
            o.Normal = UnpackNormal( tex2D( _Normal, uv_Normal48 ) );

            float2 uv_BaseColor_11 = i.uv_texcoord;
            float4 tex2DNode1 = tex2D( _BaseColor_1, uv_BaseColor_11 );

            float4 lerpResult9 = lerp( tex2DNode1 , ( tex2DNode1 * _ChangeBaseColor ) , 1.0);
            o.Albedo = lerpResult9.rgb;

            o.Smoothness = _Base_Roughness;
            o.Alpha = 1;
        }

        ENDCG

        CGPROGRAM
        #pragma surface surf Standard keepalpha fullforwardshadows
        ENDCG

        Pass
        {
            Name "ShadowCaster"
            Tags{ "LightMode" = "ShadowCaster" }
            ZWrite On
            AlphaToMask Off

            // ---- STENCIL (added) ----
            // This pass is explicit, so give it its own stencil state too.
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
            #pragma vertex vert
            #pragma fragment frag
            #pragma target 4.6
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
                float2 customPack1 : TEXCOORD1;
                float3 worldPos : TEXCOORD2;
                float4 tSpace0 : TEXCOORD3;
                float4 tSpace1 : TEXCOORD4;
                float4 tSpace2 : TEXCOORD5;
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
                half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
                half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
                half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
                o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
                o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
                o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
                o.customPack1.xy = customInputData.uv_texcoord;
                o.customPack1.xy = v.texcoord;
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
                float3 worldPos = IN.worldPos;
                half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
                SurfaceOutputStandard o;
                UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
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
