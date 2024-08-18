Shader "Unlit/MyUnlitShader/AlphaTestShadow"
{
     //透明度测试（针对镂空物体的渲染）
    Properties
    {
        _MainTex ("Texture", 2D) = "white"{}
        _Color("Color",Color)=(1,1,1,1)
        _SpecularColor("SpecularColor",Color)=(1,1,1,1)
        _SpecularNum("SpecularNum",Range(0,20))=10
        _Cutoff("Cutoff",Range(0,1))=0.5
    }
    SubShader
    {
        Tags { "Queue"="AlphaTest" "IgnoreProjector"="True" "RenderType"="TransparentCutout" }
        

        Pass
        {
            Tags {"LightMode"="ForwardBase"}
            Cull Off
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
           #pragma multi_compile_fwdbase

            #include "UnityCG.cginc"
            #include "Lighting.cginc"
            #include "AutoLight.cginc"

            
            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 pos : SV_POSITION;
                fixed3 wPos:TEXCOORD1;
                float3 worldNormal:NORMAL;
                SHADOW_COORDS(2)
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float4  _SpecularColor;
            float4 _Color;
            float _SpecularNum;
            float _Cutoff;
            v2f vert ( appdata_base v)
            {
                v2f fData;
                fData.pos = UnityObjectToClipPos(v.vertex);
                fData.uv=v.texcoord.xy*_MainTex_ST.xy+_MainTex_ST.zw;
                fData.worldNormal=UnityObjectToWorldNormal(v.normal);
                fData.wPos=mul(UNITY_MATRIX_M,v.vertex);
                TRANSFER_SHADOW(fData);
                return fData;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 texColor=tex2D(_MainTex, i.uv);
                clip(texColor.a-_Cutoff);
                //漫反射材质颜色
                float3 albedo=tex2D(_MainTex, i.uv)*_Color;
                //兰伯特光照颜色
                float3 lambertColor=_LightColor0*albedo*max(0,dot(i.worldNormal,normalize(_WorldSpaceLightPos0)));
                //半角方向向量
                float3 viewDir=UnityWorldToViewPos(i.wPos);
                float3 halfDir=normalize(viewDir+normalize(_WorldSpaceLightPos0));
                //高光反射颜色
                float3 specularColor=_LightColor0*_SpecularColor*pow(max(0,dot(halfDir,i.worldNormal)),_SpecularNum);
                UNITY_LIGHT_ATTENUATION(atten,i,i.wPos);
                //环境光颜色+Lambert漫反射颜色+高光颜色
                fixed3 color=UNITY_LIGHTMODEL_AMBIENT*albedo+(lambertColor+specularColor)*atten;
                return fixed4(color,1);
            }
            ENDCG
        }
    }
Fallback "Transparent/Cutout/VertexLit"
}
