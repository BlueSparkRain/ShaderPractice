Shader "Unlit/ReflectionDiffuse"
{
    Properties
    {
      _Color("Color",Color)=(1,1,1,1)
      _ReflectColor("ReflectColor",Color)=(1,1,1,1)
      _CubeMap("CubMap",Cube)=""{}
      _Reflectivity("Reflectivity",Range(0,1))=0.5
     
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
            float _Reflectivity;
            fixed4 _Color;
            fixed4 _ReflectColor;

            struct v2f
            {
                float4 pos : SV_POSITION;
                float3 wPos:TEXCOORD0;
                float3 wNormal:NORMAL;
                float3 wRef:TEXCOORD1;
                SHADOW_COORDS(2)
            };

            v2f vert (appdata_base v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.wPos=mul(UNITY_MATRIX_M,v.vertex);
                o.wNormal=UnityObjectToWorldNormal(v.normal);
                fixed3 wViewDir=UnityWorldSpaceViewDir(o.wPos);
                o.wRef=reflect(-wViewDir,o.wNormal);
                TRANSFER_SHADOW(o)
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed3  wLightDir=normalize(UnityWorldSpaceLightDir(i.wPos));
                fixed3 lambertColor=_Color*_LightColor0*max(0,dot( normalize(i.wNormal),wLightDir));
                //对立方体纹理进行采样
                fixed3 cubecolor=texCUBE(_CubeMap,i.wRef).xyz;
                float3 color=UNITY_LIGHTMODEL_AMBIENT+lerp(lambertColor,cubecolor,_Reflectivity);
                return fixed4(color,1);
            }
            ENDCG
        }
    }
Fallback "Legacy Shaders/Reflective/VertexLit"
}
