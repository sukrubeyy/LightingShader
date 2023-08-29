<ul>
<li>Diffuse Lighting</li>
<p>
Diffuse computes a simple (Lambertian) lighting model. The lighting on the surface decreases as the angle between it and the light decreases. The lighting depends only on this angle, and does not change as the camera. The output is either drawn to the screen or captured as a texture.
</p>
<img src="https://github.com/sukrubeyy/LightingShader/blob/main/Assets/Images/Diffuse.gif"/>
<pre>
<code>
Shader "Unlit/DiffuseShader"
{
    Properties{}
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
</code>
</pre>
<li>Specular Lighting</li>
<p>
Specular computes the same simple (Lambertian) lighting as Diffuse, plus a viewer dependent specular highlight. This is called the Blinn-Phong lighting model. It has a specular highlight that is dependent on surface angle, light angle, and viewing angle.
</p>
<ul>
<li>Phong</li>
<img src="https://github.com/sukrubeyy/LightingShader/blob/main/Assets/Images/Phong.gif"/>
<pre>
<code>
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


</code>
</pre>
<li>Bling Phong + Attenuation </li>
<img src="https://github.com/sukrubeyy/LightingShader/blob/main/Assets/Images/BlingPhong.gif"/>
<pre>
<code>
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


</code>
</pre>

<li>Fresnel Effect</li>
<img src="https://github.com/sukrubeyy/LightingShader/blob/main/Assets/Images/Fresnel.gif"/>
<pre>
<code>
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
</code>
</pre>
</ul>

