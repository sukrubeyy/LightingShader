#include "UnityCG.cginc"
            #include "AutoLight.cginc"
            #include "Lighting.cginc"

            struct MeshData
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
            };

            struct Interpolator
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float3 normal : TEXCOORD1;
                float3 wPos : TEXCOORD2;
                LIGHTING_COORDS(3,4)
            };

            float _Gloss;

            Interpolator vert (MeshData v)
            {
                Interpolator o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.normal = UnityObjectToWorldNormal(v.normal);
                o.uv = v.uv;
                o.wPos = mul(unity_ObjectToWorld,v.vertex);
                TRANSFER_VERTEX_TO_FRAGMENT(o);
                return o;
            }

            float4 frag (Interpolator i) : SV_Target
            {
                float3 V = normalize(_WorldSpaceCameraPos - i.wPos);
                float3 N = normalize(i.normal);
                float3 L = _WorldSpaceLightPos0.xyz;
                float3 lambert = saturate(dot(L,N));
                float3 H = normalize(L + V);
                float attenuation = LIGHT_ATTENUATION(i);
                float3 specularLight = saturate(dot(H,N)) * (lambert>0);
                float specularExponent = exp2(_Gloss * 11 )+2;
                specularLight= pow(specularLight,specularExponent)*_Gloss*attenuation;
                specularLight*=_LightColor0.xyz;
                return float4(specularLight,1);
            }