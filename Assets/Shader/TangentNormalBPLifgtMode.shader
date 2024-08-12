Shader "Unlit/TangentNormalBPLifgtMode"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _MainColor("MainColor",Color)=(1,1,1,1)
        _SpecularColor("SpecularColor",Color)=(1,1,1,1)
        _SpecularNum("SpecularNum",Range(0,30))=10
        _BumpTex("BumpTex",2D)="white" {}
        _BumpScale("BumpScale",Range(0,1))=1
    }
    SubShader//切线空间下计算法线贴图
    {
        Tags { "LightMode"="ForwardBase" }
        

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
                float4 uv : TEXCOORD0;
                //切线空间下光照方向
                float3 lightDir:TEXCOORD1;
                //切线空间下视角方向
                float3 viewDir:TEXCOORD2;
             
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float4 _MainColor;
            float4 _SpecularColor;
            float _SpecularNum;
            sampler2D _BumpTex;
            float4 _BumpTex_ST;
            float _BumpScale;

            v2f vert (appdata_full v)
            {
             v2f fData;
                fData.vertex=UnityObjectToClipPos(v.vertex);
                fData.uv.xy=v.texcoord.xy*_MainTex_ST.xy+_MainTex_ST.zw;
                fData.uv.zw=v.texcoord.xy*_BumpTex_ST.xy+_BumpTex_ST.zw;

                float3 binormal=cross(normalize(v.tangent),normalize(v.normal));
                //从模型空间到切线空间的变换矩阵
                fixed3x3  TangentSpaceTransM=fixed3x3(
                    v.tangent.xyz,
                    binormal,
                    v.normal
                );
                
                fData.lightDir=mul(TangentSpaceTransM,ObjSpaceLightDir(v.vertex))  ;
                fData.viewDir=mul(TangentSpaceTransM,ObjSpaceViewDir(v.vertex));
                return  fData;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float4 packedNormal=tex2D(_BumpTex,i.uv.zw);
                float3 tangentNormal=UnpackNormal(packedNormal);
                tangentNormal.xy*=_BumpScale;
                tangentNormal.z=sqrt(1-saturate(dot(tangentNormal.xy,tangentNormal.xy)));
                //漫反射材质颜色
                float3 albedo=tex2D(_MainTex,i.uv.xy)*_MainColor;
                //Lambert颜色
                
                float3 lambertColor=_LightColor0*albedo*(max(0,dot(tangentNormal, normalize(i.lightDir)))*0.5+0.5);
               // float3 lambertColor=_LightColor0*albedo*max(0,dot(tangentNormal, normalize(i.lightDir)));
                //BP高光颜色
                float3 halfDir=normalize(normalize(i.lightDir)+normalize(i.viewDir)) ;
                float3 specularColor=_LightColor0*_SpecularColor*pow(max(0,dot(tangentNormal,halfDir)),_SpecularNum);

                float3 color=albedo*UNITY_LIGHTMODEL_AMBIENT+lambertColor+specularColor;
                return  fixed4(color,1);
            
            }
            ENDCG
        }
    }

 
}
