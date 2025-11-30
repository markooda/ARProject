Shader "Custom/SimpleCartoonShader"
{
    Properties
    {
        _MainTex ("Base (RGB)", 2D) = "white" {}
        _PosterizeLevels ("Posterize Levels", Range(2,8)) = 4
        _EdgeThreshold ("Edge Threshold", Range(0.1,1)) = 0.3
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        Pass
        {
            ZTest Always Cull Off ZWrite Off

            CGPROGRAM
            #pragma vertex vert_img
            #pragma fragment frag
            #include "UnityCG.cginc"

            sampler2D _MainTex;
            float _PosterizeLevels;
            float _EdgeThreshold;

            fixed4 frag(v2f_img i) : SV_Target
            {
                float2 uv = i.uv;
                fixed4 col = tex2D(_MainTex, uv);

                // --- Simple edge detection using luminance difference ---
                float3 center = col.rgb;
                float3 left = tex2D(_MainTex, uv + float2(-0.002, 0)).rgb;
                float3 right = tex2D(_MainTex, uv + float2(0.002, 0)).rgb;
                float3 up = tex2D(_MainTex, uv + float2(0, 0.002)).rgb;
                float3 down = tex2D(_MainTex, uv + float2(0, -0.002)).rgb;

                float lumCenter = dot(center, float3(0.299, 0.587, 0.114));
                float lumLeft   = dot(left,   float3(0.299, 0.587, 0.114));
                float lumRight  = dot(right,  float3(0.299, 0.587, 0.114));
                float lumUp     = dot(up,     float3(0.299, 0.587, 0.114));
                float lumDown   = dot(down,   float3(0.299, 0.587, 0.114));

                float edge = step(_EdgeThreshold, abs(lumCenter - lumLeft)
                                             + abs(lumCenter - lumRight)
                                             + abs(lumCenter - lumUp)
                                             + abs(lumCenter - lumDown));

                // --- Posterize colors ---
                col.rgb = floor(col.rgb * _PosterizeLevels) / _PosterizeLevels;

                // --- Apply edges ---
                col.rgb = lerp(col.rgb, float3(0,0,0), edge);

                return col;
            }
            ENDCG
        }
    }
}
