Shader "Custom/UnlitTextureWithStencil"
{
    Properties
    {
        _MainTex ("Base (RGB)", 2D) = "white" {}
        _MainTex_ST ("UV Tiling/Offset", Vector) = (1,1,0,0)
    }

    SubShader
    {
        Tags { "RenderType"="Opaque" "Queue"="Geometry" }

        Cull Off
        ZWrite On
        ZTest LEqual

        Stencil
        {
            Ref 1
            Comp Equal
            Pass Keep
        }

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma target 3.0

            #include "UnityCG.cginc"

            sampler2D _MainTex;
            float4 _MainTex_ST;

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            v2f vert(appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);

                // manual equivalent of TRANSFORM_TEX
                o.uv = v.uv * _MainTex_ST.xy + _MainTex_ST.zw;

                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                col.a = 1.0; // fully opaque
                return col;
            }
            ENDCG
        }
    }

    FallBack "Unlit/Texture"
}
