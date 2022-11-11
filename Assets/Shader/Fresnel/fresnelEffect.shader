Shader "Unlit/fresnelEffect"
{
    Properties
    {
        _fresnelColor("Color",Color)=(1,1,1,1)
        _InsideLight("Inside",Color)=(1,1,1,1)
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

            struct meshData
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
            };

            struct Interpolators
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float3 normal : TEXCOORD1;
                float3 worldPos : TEXCOORD2;
            };
        float4 _fresnelColor;
        float4 _InsideLight;
            Interpolators vert (meshData v)
            {
                Interpolators o;
                
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                o.normal = UnityObjectToWorldNormal(v.normal);
                o.worldPos = mul(unity_ObjectToWorld,v.vertex);
                return o;
            }

            float4 frag (Interpolators i) : SV_Target
            {
                float3 V = normalize(_WorldSpaceCameraPos-i.worldPos);
                float3 N = normalize(i.normal);
                float fresnel = (1-dot(V,N))*(cos(_Time.y*4));

                return fresnel * _fresnelColor;
            }
            ENDCG
        }
    }
}
