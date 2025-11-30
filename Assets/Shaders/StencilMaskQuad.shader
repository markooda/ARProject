Shader "Custom/ARMask"
{
    SubShader
    {
        Tags { "Queue" = "Geometry-10" }

        // Do NOT write color or depth
        ColorMask 0
        ZWrite Off

        Stencil
        {
            Ref 1
            Comp Always
            Pass Replace
        }

        Pass { }
    }
}
