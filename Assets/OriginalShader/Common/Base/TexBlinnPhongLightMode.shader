Shader "Unlit/MyUnlitShader/TexBlinnPhongLightMode"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white"{}
        _MainColor("MainColor",Color)=(1,1,1,1)
        _SpecularColor("SpecularColor",Color)=(1,1,1,1)
        _SpecularNum("SpecularNum",Range(0,20))=10
    }
    SubShader
    {
        Tags { "LightingMode"="ForwardBase" }
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
           

            #include "UnityCG.cginc"
            #include "Lighting.cginc"

            
            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float3 worldVertex:TEXCOORD1;
                float3 worldNormal:NORMAL;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float4  _SpecularColor;
            float4  _MainColor;
            float _SpecularNum;
            v2f vert ( appdata_base v)
            {
                v2f fData;
                fData.vertex = UnityObjectToClipPos(v.vertex);
                fData.uv=v.texcoord.xy*_MainTex_ST.xy+_MainTex_ST.zw;
                fData.worldNormal=UnityObjectToWorldNormal(v.normal);
                fData.worldVertex=mul(UNITY_MATRIX_M,v.vertex);
                return fData;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                //漫反射材质颜色
                float3 albedo=tex2D(_MainTex, i.uv)*_MainColor;
                //兰伯特光照颜色
                float3 lambertColor=_LightColor0*albedo*max(0,dot(i.worldNormal,normalize(_WorldSpaceLightPos0)));
                //半角方向向量
                float3 viewDir=UnityWorldToViewPos(i.worldVertex);
                float3 halfDir=normalize(viewDir+normalize(_WorldSpaceLightPos0));
                //高光反射颜色
                float3 specularColor=_LightColor0*_SpecularColor*pow(max(0,dot(halfDir,i.worldNormal)),_SpecularNum);
                //环境光颜色+Lambert漫反射颜色+高光颜色
                float3 color=UNITY_LIGHTMODEL_AMBIENT*albedo+lambertColor+specularColor;
                return fixed4(color,1);
            }
            ENDCG
        }
    }
}
