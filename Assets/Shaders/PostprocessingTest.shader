Shader "Custom/AdvancedCartoonPost"
{
    Properties
    {
        _MainTex ("Base (RGB)", 2D) = "white" {}
        _PosterizeLevels ("Posterize Levels", Range(2,16)) = 8
        _EdgeThreshold ("Edge Threshold", Range(0.01,1)) = 0.2
        _EdgeThickness ("Edge Thickness", Range(1,5)) = 2
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
            float _EdgeThickness;

            fixed4 frag(v2f_img i) : SV_Target
            {
                float2 uv = i.uv;
                fixed4 col = tex2D(_MainTex, uv);

                // --- Posterize ---
                col.rgb = floor(col.rgb * _PosterizeLevels) / _PosterizeLevels;

                // --- Edge detection (luminance + neighborhood sampling) ---
                float lumCenter = dot(col.rgb, float3(0.299,0.587,0.114));
                float edge = 0;

                // Sample a small square around pixel for thicker edges
                for (float x = -_EdgeThickness/1000.0; x <= _EdgeThickness/1000.0; x += _EdgeThickness/2000.0)
                {
                    for (float y = -_EdgeThickness/1000.0; y <= _EdgeThickness/1000.0; y += _EdgeThickness/2000.0)
                    {
                        float3 sampleCol = tex2D(_MainTex, uv + float2(x,y)).rgb;
                        float lumSample = dot(sampleCol, float3(0.299,0.587,0.114));
                        edge += step(_EdgeThreshold, abs(lumCenter - lumSample));
                    }
                }

                edge = clamp(edge,0,1);

                // Apply edge
                col.rgb = lerp(col.rgb, float3(0,0,0), edge);

                return col;
            }
            ENDCG
        }
    }
}
