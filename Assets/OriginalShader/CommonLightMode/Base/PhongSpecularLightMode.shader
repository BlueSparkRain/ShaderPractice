Shader "Unlit/MyUnlitShader/PhongSpecularLightMode"
{
    Properties
    {
      _SpecularColor("SpecularColor",COLOR)=(1,1,1,1)
        _SpecularNum("SpecularNum",Range(0,20))=0.5
    }
    SubShader//逐片元着色器实现phong高光反射模型
    {
        Tags { "LightingMode"="ForwardBase" }
     
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
          
            #include "UnityCG.cginc"
            #include  "Lighting.cginc"
           
             struct v2f
            {
             
                float3 vcolor:COLOR;
                float4 vertex : SV_POSITION;
                float3 worldNormal:NORMAL;
                float4 worldvvertex:TEXCOORD0;
            };

            fixed4 _SpecularColor;
            float   _SpecularNum;
            v2f vert (appdata_base v)
            {
                v2f fData;
                fData.vertex = UnityObjectToClipPos(v.vertex);
                fixed4 worldPos=mul(UNITY_MATRIX_M,v.vertex);
                fData.worldvvertex=worldPos;
                fixed3 normal=UnityObjectToWorldNormal(v.normal);
                fData.worldNormal=normal;
                return fData;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                //得到反射光线方向向量
                fixed3 lightDir= normalize( _WorldSpaceLightPos0);
                fixed3 reflectDir= normalize(reflect(-lightDir,i.worldNormal));
                //得到视线方向向量
                fixed3 viewDir= normalize(fixed3(_WorldSpaceCameraPos-i.worldvvertex));
                fixed3 color  =_SpecularColor*_LightColor0*pow(max(0, dot(viewDir,reflectDir)),_SpecularNum);
                i.vcolor=color;
                return fixed4( i.vcolor,1);
            }
            ENDCG
        }
}
    SubShader//逐顶点着色器实现phong
    {
        Tags { "LightingMode"="ForwardBase" }
     
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
          

            #include "UnityCG.cginc"
            #include  "Lighting.cginc"
           

             struct v2f
            {
             
                float3 vcolor:COLOR;
                float4 vvertex : SV_POSITION;
            };

            fixed4 _SpecularColor;
            float   _SpecularNum;
            v2f vert (appdata_base v)
            {
                v2f fData;
                fData.vvertex = UnityObjectToClipPos(v.vertex);
                //得到视线方向向量
                fixed4  worldPos=mul(UNITY_MATRIX_M,v.vertex);
                fixed3 viewDir= normalize(fixed3(_WorldSpaceCameraPos-worldPos));
                //得到反射光线方向向量
                fixed3 lightDir= normalize( _WorldSpaceLightPos0);
                fixed3 normal=UnityObjectToWorldNormal(v.normal);
                fixed3 reflectDir= normalize(reflect(-lightDir,normal));
                fixed3 color  =_SpecularColor*_LightColor0*pow(max(0, dot(viewDir,reflectDir)),_SpecularNum);
                fData.vcolor=color;
                return fData;
            }

            fixed4 frag (v2f i) : SV_Target
            {
              
                return fixed4( i.vcolor,1);
            }
            ENDCG
        }
    }
}

