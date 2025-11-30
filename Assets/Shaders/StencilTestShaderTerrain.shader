
Shader "Custom/TerrainSplat_WithStencil"
{
    Properties
    {
        _Control ("Control (RGBA)", 2D) = "white" {}
        _Splat0 ("Splat 0 (RGB)", 2D) = "white" {}
        _Splat1 ("Splat 1 (RGB)", 2D) = "white" {}
        _Splat2 ("Splat 2 (RGB)", 2D) = "white" {}
        _Splat3 ("Splat 3 (RGB)", 2D) = "white" {}
        _Normal0 ("Normal 0", 2D) = "bump" {}
        _Normal1 ("Normal 1", 2D) = "bump" {}
        _Normal2 ("Normal 2", 2D) = "bump" {}
        _Normal3 ("Normal 3", 2D) = "bump" {}
        _Tile0 ("Tile 0", Float) = 1.0
        _Tile1 ("Tile 1", Float) = 1.0
        _Tile2 ("Tile 2", Float) = 1.0
        _Tile3 ("Tile 3", Float) = 1.0
        _Smoothness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
    }

    SubShader
    {
        Tags { "RenderType"="Opaque" "Queue"="Geometry" }
        LOD 200

        // -------- Stencil test: only render where stencil == 1 --------
        Stencil
        {
            Ref 1
            Comp Equal
            Pass Keep
        }

        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows
        #pragma target 3.0

        sampler2D _Control;
        sampler2D _Splat0;
        sampler2D _Splat1;
        sampler2D _Splat2;
        sampler2D _Splat3;

        sampler2D _Normal0;
        sampler2D _Normal1;
        sampler2D _Normal2;
        sampler2D _Normal3;

        float _Tile0;
        float _Tile1;
        float _Tile2;
        float _Tile3;

        half _Smoothness;
        half _Metallic;

        struct Input
        {
            float2 uv_Control;
            float2 uv_Splat0;
            float2 uv_Splat1;
            float2 uv_Splat2;
            float2 uv_Splat3;
        };

        inline fixed4 SampleSplat(sampler2D tex, float2 uv, float tile)
        {
            return tex2D(tex, uv * tile);
        }

        // unpack normal (assumes normal maps stored in typical way)
        inline float3 UnpackNrmFixed4(fixed4 n)
        {
            return normalize(UnpackNormal(n));
        }

        void surf(Input IN, inout SurfaceOutputStandard o)
        {
            fixed4 ctrl = tex2D(_Control, IN.uv_Control);

            // sample albedos
            fixed4 a0 = SampleSplat(_Splat0, IN.uv_Splat0, _Tile0);
            fixed4 a1 = SampleSplat(_Splat1, IN.uv_Splat1, _Tile1);
            fixed4 a2 = SampleSplat(_Splat2, IN.uv_Splat2, _Tile2);
            fixed4 a3 = SampleSplat(_Splat3, IN.uv_Splat3, _Tile3);

            // weights from control map channels (assume control channels are already normalized by artist)
            float w0 = ctrl.r;
            float w1 = ctrl.g;
            float w2 = ctrl.b;
            float w3 = ctrl.a;

            // optional: normalize weights to avoid dark areas if artist didn't pack properly
            float sum = max(w0 + w1 + w2 + w3, 1e-5);
            w0 /= sum; w1 /= sum; w2 /= sum; w3 /= sum;

            // final albedo
            fixed3 albedo = a0.rgb * w0 + a1.rgb * w1 + a2.rgb * w2 + a3.rgb * w3;
            o.Albedo = albedo;

            // Smoothness/Metallic: you can expose per-splat maps; for simplicity we use global values
            o.Smoothness = _Smoothness;
            o.Metallic = _Metallic;

            // Normals: sample and blend (simple weighted sum then renormalize)
            float3 n0 = UnpackNrmFixed4(tex2D(_Normal0, IN.uv_Splat0 * _Tile0));
            float3 n1 = UnpackNrmFixed4(tex2D(_Normal1, IN.uv_Splat1 * _Tile1));
            float3 n2 = UnpackNrmFixed4(tex2D(_Normal2, IN.uv_Splat2 * _Tile2));
            float3 n3 = UnpackNrmFixed4(tex2D(_Normal3, IN.uv_Splat3 * _Tile3));

            float3 blendedN = normalize(n0 * w0 + n1 * w1 + n2 * w2 + n3 * w3);
            o.Normal = blendedN;

            // no alpha
            o.Alpha = 1;
        }
        ENDCG
    }

    FallBack "Diffuse"
}
