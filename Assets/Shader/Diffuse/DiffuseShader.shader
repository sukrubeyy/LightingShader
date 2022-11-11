Shader "Unlit/DiffuseShader"
{
    Properties
    {
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            #include "Lighting.cginc"
            #include "AutoLight.cginc"

            struct meshData
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 uv : TEXCOORD0;
            };

            struct fragment
            {
                float2 uv : TEXCOORD0;
                float3 normal : TEXCOORD1;
                float4 vertex : SV_POSITION;
            };


            fragment vert (meshData v)
            {
                fragment o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.normal = UnityObjectToWorldNormal(v.normal);
                o.uv = v.uv;

                return o;
            }

            fixed4 frag (fragment i) : SV_Target
            {
                float3 N = i.normal;
                float3 L = _WorldSpaceLightPos0.xyz; // Light Ray direction
                float3 diffuseLighting = max(0,dot(N,L)) * _LightColor0.xyz;
                return float4(diffuseLighting,1);
            }
            ENDCG
        }
    }
}
