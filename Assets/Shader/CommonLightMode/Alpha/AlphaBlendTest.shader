Shader "Unlit/AlphaBlendTest"
{
    //透明度混合（针对半透明物体的渲染）  //开启深度写入的半透明效果
     Properties
    {
        _MainTex ("Texture", 2D) = "white"{}
        _MainColor("MainColor",Color)=(1,1,1,1)
        _SpecularColor("SpecularColor",Color)=(1,1,1,1)
        _SpecularNum("SpecularNum",Range(0,20))=10
        _AlphaScale("AlphaScale",Range(0,1))=1
    }
    SubShader
    {
       Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}
      
     
       pass//该通道只进行深度写入但不输出颜色
       {
          
           ZWrite On
           ColorMask 0
       }
        Pass
        {
             Tags { "LightingMode"="ForwardBase" }
        
          
             ZWrite Off
             Blend SrcAlpha OneMinusSrcAlpha

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
            float _AlphaScale;
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
                fixed4 texColor=tex2D(_MainTex, i.uv);
                
                //漫反射材质颜色
                float3 albedo=tex2D(_MainTex, i.uv).rgb*_MainColor.rgb;
                //兰伯特光照颜色
                float3 lambertColor=_LightColor0.rgb*albedo.rgb*max(0,dot(i.worldNormal,normalize(_WorldSpaceLightPos0)));
                //半角方向向量
                float3 viewDir=UnityWorldToViewPos(i.worldVertex);
                float3 halfDir=normalize(viewDir+normalize(_WorldSpaceLightPos0));
                //高光反射颜色
                float3 specularColor=_LightColor0.rgb*_SpecularColor.rgb*pow(max(0,dot(halfDir,i.worldNormal)),_SpecularNum);
                //环境光颜色+Lambert漫反射颜色+高光颜色
                float3 color=UNITY_LIGHTMODEL_AMBIENT*albedo+lambertColor+specularColor;
                return fixed4(color,_AlphaScale);
            }
            ENDCG
        }
    
    
    }
}
