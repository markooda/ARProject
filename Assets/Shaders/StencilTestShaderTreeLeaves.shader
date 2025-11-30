Shader "Custom/TreeLeavesWithStencil"
{
    Properties
    {
        _Color ("Main Color", Color) = (1,1,1,1)
        _MainTex ("Main Texture", 2D) = "white" {}
        _Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
    }

    SubShader
    {
        Tags { "Queue"="AlphaTest" "RenderType"="TransparentCutout" }

        Cull Off
        Lighting On
        ZWrite On

        Stencil
        {
            Ref 1
            Comp Equal
            Pass Keep
        }

        CGPROGRAM
        #pragma surface surf Lambert alpha:clip fullforwardshadows
        #pragma target 3.0

        sampler2D _MainTex;
        fixed4 _Color;
        float _Cutoff;

        struct Input
        {
            float2 uv_MainTex;
        };

        void surf(Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;

            // Alpha cutout
            clip(c.a - _Cutoff);

            o.Albedo = c.rgb;
            o.Alpha = c.a;
        }
        ENDCG
    }

    FallBack "Transparent/Cutout/VertexLit"
}
