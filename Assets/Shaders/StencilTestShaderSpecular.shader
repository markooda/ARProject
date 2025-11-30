Shader "Custom/StandardSpecular_Cutout_Stencil"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB) Alpha (A)", 2D) = "white" {}
        _SpecTint ("Specular Tint", Color) = (0.2,0.2,0.2,1)
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _AlphaCutoff ("Alpha Cutoff", Range(0,1)) = 0.5
    }

    SubShader
    {
        Tags
        {
            "RenderType"="AlphaTest"
            "Queue"="AlphaTest"
        }
        LOD 200

        Stencil
        {
            Ref 1
            Comp Equal
            Pass Keep
        }

        CGPROGRAM
        #pragma surface surf StandardSpecular fullforwardshadows alphatest:_AlphaCutoff
        #pragma target 3.0

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
        };

        fixed4 _Color;
        fixed4 _SpecTint;
        half _Glossiness;

        UNITY_INSTANCING_BUFFER_START(Props)
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutputStandardSpecular o)
        {
            fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;

            o.Albedo = c.rgb;
            o.Specular = _SpecTint.rgb;
            o.Smoothness = _Glossiness;

            o.Alpha = c.a; // Used for cutout
        }
        ENDCG
    }

    FallBack "Specular"
}
