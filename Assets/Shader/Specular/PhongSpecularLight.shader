Shader "Unlit/Specular"
{
    Properties
    {
        _Gloss("GlossPower",Range(0,1))=0
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

            #include "AutoLight.cginc"
            #include "Lighting.cginc"

            struct meshdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 uv : TEXCOORD0;
            };

            struct Interpolator
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float3 normal : TEXCOORD1;
                float3 wPos : TEXCOORD2;
            };

            float _Gloss;
            Interpolator vert (meshdata v)
            {
                Interpolator o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.normal = mul(UNITY_MATRIX_M,v.normal);
                o.uv = v.uv;
                o.wPos = mul(unity_ObjectToWorld,v.vertex);
                return o;
            }

            float4 frag (Interpolator i) : SV_Target
            {
                float3 L = _WorldSpaceLightPos0.xyz; // take Light Direction
                float3 V = normalize(_WorldSpaceCameraPos - i.wPos); // View Direction 
                float3 N = normalize(i.normal);
                float3 R = reflect(-L,N);
                float3 specularLight = saturate(dot(V,R));
                specularLight=pow(specularLight,_Gloss);
                return float4(specularLight,1);
            }
            ENDCG
        }
    }
}
