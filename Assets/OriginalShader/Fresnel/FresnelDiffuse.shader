Shader "Unlit/MyUnlitShader/Fresnel/FresnelDiffuse"
{
    Properties
    {
        //漫反射颜色
      _Color("Color",Color)=(1,1,1,1)
          // Fresnel反射中，介质对应的反射率
     _FresnelScale("FresnelScale",Range(0,1))=1
     
      _CubeMap("CubMap",Cube)=""{}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" "Queue"="Geometry"}
        Pass
        {
            Tags {"LightMode"="ForwardBase"}
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma  multi_compile_fwdbasealpha

            #include "UnityCG.cginc"
            #include  "Lighting.cginc"
            #include  "AutoLight.cginc"
            
            samplerCUBE _CubeMap;
            fixed4 _Color;
            fixed _FresnelScale;
            
            struct v2f
            {
                float4 pos : SV_POSITION;
                float3 wPos:TEXCOORD0;
                float3 wNormal:NORMAL;
                float3 wRefrac:TEXCOORD1;
                float3 wViewDir:TEXCOORD2;
                SHADOW_COORDS(3)
            };

            v2f vert (appdata_base v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.wPos=mul(UNITY_MATRIX_M,v.vertex);
                o.wNormal=UnityObjectToWorldNormal(v.normal);
                o.wViewDir=UnityWorldSpaceViewDir(o.wPos);
                o.wRefrac=reflect(-o.wViewDir,o.wNormal);
                TRANSFER_SHADOW(o)
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                //获取漫反射颜色
                fixed3  wLightDir=normalize(UnityWorldSpaceLightDir(i.wPos));
                fixed3 diffuseColor=_Color*_LightColor0*max(0,dot( normalize(i.wNormal),wLightDir));
                //对立方体纹理进行采样
                fixed3 cubecolor=texCUBE(_CubeMap,i.wRefrac).xyz;
                UNITY_LIGHT_ATTENUATION(atten,i,i.wPos);

                fixed fresnel=_FresnelScale+(1-_FresnelScale)*pow(1-dot(normalize(i.wNormal),normalize(i.wViewDir)),5);
                float3 color=UNITY_LIGHTMODEL_AMBIENT+lerp(diffuseColor,cubecolor,fresnel)*atten;
                return fixed4(color,1);
            }
            ENDCG
        }
    }
Fallback "Legacy Shaders/Reflective/VertexLit"
}
