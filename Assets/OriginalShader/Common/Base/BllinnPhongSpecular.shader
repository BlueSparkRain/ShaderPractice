Shader "Unlit/MyUnlitShader/BllinnPhongSpecular"
{
    Properties
    {
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
                float4 vertex : SV_POSITION;
                float3 wNormal:TEXCOORD0;
                float4 wVertex:TEXCOORD1;
                float4  color:COLOR;
            };

           float4 _SpecularColor;
            float _SpecularNum;

            v2f vert (appdata_base v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.wNormal=UnityObjectToWorldNormal(v.normal);
                o.wVertex=mul(UNITY_MATRIX_M,v.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                //计算视角方向向量
                float3 viewDir=normalize(_WorldSpaceCameraPos-i.wVertex);
                //计算半角方向向量
                float3 halfDir=normalize(viewDir+_WorldSpaceLightPos0);
                //计算高光
                float3 color=_LightColor0*_SpecularColor*pow(max(0,dot(i.wNormal,halfDir)),_SpecularNum);
                i.color= fixed4(color,1);
                return i.color;
            }
            ENDCG
        }
    }
}
