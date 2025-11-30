Shader "Custom/TreeSoftOcclusionBarkStencil"
{
    Properties {
        _Color ("Main Color", Color) = (1,1,1,1)
        _MainTex ("Main Texture", 2D) = "white" {}
        _BaseLight ("Base Light", Range(0,1)) = 0.35
        _AO ("Amb. Occlusion", Range(0,10)) = 2.4
    }

    SubShader {
        Tags { "IGNOREPROJECTOR"="true" "RenderType"="TreeOpaque" "DisableBatching"="true" }

        Pass {
            Tags { "IGNOREPROJECTOR"="true" "RenderType"="TreeOpaque" "DisableBatching"="true" }

            Stencil {
                Ref 1
                Comp Equal
                Pass Keep
            }

            Lighting On
        }

        Pass {
            Name "ShadowCaster"
            Tags { "LIGHTMODE"="SHADOWCASTER" "IGNOREPROJECTOR"="true" "SHADOWSUPPORT"="true" "RenderType"="TreeOpaque" "DisableBatching"="true" }

            Stencil {
                Ref 1
                Comp Equal
                Pass Keep
            }

        }
    }

    Fallback Off
}
