Shader "Unlit/BlingPhongSpecular"
{
    Properties
    {
        _Gloss("Gloss",float)=0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        Pass
        {
            Tags{"LightMode"="ForwardBase"}

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "Assets/Shader/CG/ShaderCG.cginc"

            ENDCG
        }
         Pass
        {
            Blend One One
            Tags{"LightMode"="ForwardAdd"}

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_fwdadd

            #include "Assets/Shader/CG/ShaderCG.cginc"

            ENDCG
        }
    }
}
