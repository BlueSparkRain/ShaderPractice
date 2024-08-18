Shader "Unlit/MyUnlitShader/Refract/RefractDiffuse"
{
    Properties
    {
        //漫反射颜色
      _Color("Color",Color)=(1,1,1,1)
      //折射颜色
      _RefractColor("RefractColor",Color)=(1,1,1,1)
      _CubeMap("CubMap",Cube)=""{}
      //介质1折射率/介质2折射率
      _RefractRation("efractRation",Range(0.1,1))=0.5
      //折射强度
      _RefractIntensity("RefractIntensity",Range(0,1))=1
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
            fixed4 _RefractColor;
            float _RefractRation;
            float _RefractIntensity;

            struct v2f
            {
                float4 pos : SV_POSITION;
                float3 wPos:TEXCOORD0;
                float3 wNormal:NORMAL;
                float3 wRefrac:TEXCOORD1;
                SHADOW_COORDS(2)
            };

            v2f vert (appdata_base v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.wPos=mul(UNITY_MATRIX_M,v.vertex);
                o.wNormal=UnityObjectToWorldNormal(v.normal);
                fixed3 wViewDir=UnityWorldSpaceViewDir(o.wPos);
                o.wRefrac=refract(- normalize(wViewDir),o.wNormal,_RefractRation);
                TRANSFER_SHADOW(o)
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed3  wLightDir=normalize(UnityWorldSpaceLightDir(i.wPos));
                fixed3 diffuseColor=_Color*_LightColor0*max(0,dot( normalize(i.wNormal),wLightDir));
                //对立方体纹理进行采样
                fixed3 cubecolor=texCUBE(_CubeMap,i.wRefrac).xyz*_RefractColor;
                UNITY_LIGHT_ATTENUATION(atten,i,i.wPos);
                float3 color=UNITY_LIGHTMODEL_AMBIENT+lerp(diffuseColor,cubecolor,_RefractIntensity)*atten;
                return fixed4(color,1);
            }
            ENDCG
        }
    }
Fallback "Legacy Shaders/Reflective/VertexLit"
}
