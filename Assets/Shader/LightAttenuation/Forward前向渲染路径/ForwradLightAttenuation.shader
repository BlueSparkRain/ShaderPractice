Shader "Unlit/ForwradLightAttenuation"
{
    //前向渲染路径中处理点光源和聚光源
     //Phong光照模型=环境光模型+Lambert（漫反射）光照模型 + BlinnPhong高光反射光照模型
    Properties
    {
   
         _MainColor("Color",Color)= (1,1,1,1)
         _SpecularColor("SpecularColor",COLOR)=(1,1,1,1)
        _SpecularNum("SpecularNum",Range(0,20))=0.5
    }
     SubShader//逐片元着色器实现Phong光照模型(效果比逐顶点更好)
    {
       
        Pass//前向 BasePass 基础渲染通道
        {
             Tags { "LightMode"="ForwardBase" } 
            CGPROGRAM
             #include "UnityCG.cginc"
             #include "Lighting.cginc"
             
            #pragma vertex vert
            #pragma fragment frag
             
            #pragma  mutli_compile_fwdbase
            //确保在shader中使用光照衰减相关光照变量能正确赋值到对应的内置变量中，并且会帮我们编译Bass Pass中的所有变体

            struct v2f
            {
               float4 vertex : SV_POSITION;
               float3 color :COLOR;
               float3 worldNormal:NORMAL;
               float4 worldVertex:TEXCOORD0;
            };
             
            fixed4 _MainColor;
            fixed4 _SpecularColor;
            float  _SpecularNum;
             
             //获取Lambert光照模型
           fixed3 GetLambertLMode(fixed3 worldNormal)
           {
               //获取相对于世界坐标系下的法线信息
               fixed3 lightDir=normalize(_WorldSpaceLightPos0) ;
               fixed3 baseColor=_MainColor*_LightColor0*max(0,dot(worldNormal, lightDir));
               //为了阴影处不是全黑，加上Lambert环境光颜色公共变量
                baseColor=baseColor+UNITY_LIGHTMODEL_AMBIENT;
               return  baseColor;
           }

           fixed3 GetBlinnPhongSepecularLMode(fixed3 worldNormal,fixed4 worldVertex)
           {
               //得到视线方向向量
               fixed3 viewDir= normalize(fixed3(_WorldSpaceCameraPos-worldVertex));
                //得到反射光线方向向量
               fixed3 lightDir= normalize( _WorldSpaceLightPos0);
                //计算半角方向向量
               fixed3 halfDir=normalize(viewDir+lightDir);
                
               
                fixed3 color =_SpecularColor*_LightColor0*pow(max(0, dot(worldNormal,halfDir)),_SpecularNum);
                return  color;
           }
             
            v2f vert (appdata_base v)
            {
                v2f f;
               //将模型空间下的顶点转换到裁剪空间下
               f.vertex = UnityObjectToClipPos(v.vertex);
               f.worldNormal=UnityObjectToWorldNormal(v.normal);
               f.worldVertex=mul(UNITY_MATRIX_M,v.vertex);
               return f;
               
            }

            fixed4 frag (v2f i) : SV_Target
            {
                
                fixed3 lambertColor=GetLambertLMode(i.worldNormal);
                fixed3 phongSpecularColor=GetBlinnPhongSepecularLMode(i.worldNormal,i.worldVertex);
                //光照衰减值
                fixed atten=1;
                //衰减值  与  Lambert和Specular颜色的和 进行乘法混合
                fixed3 phongColor=UNITY_LIGHTMODEL_AMBIENT+(lambertColor+phongSpecularColor)*atten;
                i.color=phongColor;
                return fixed4(i.color,1);
            }
            ENDCG
        }

 
        Pass//前向 Additional Pass 附加渲染通道
        {
             Tags { "LightMode"="ForwardAdd" } 
             Blend One One//混合叠加（类线性减淡效果）
             
            CGPROGRAM
             #include "UnityCG.cginc"
             #include "Lighting.cginc"
             #pragma vertex vert
            #pragma fragment frag
        
            #pragma  multi_compile_fwdadd
            //确保在shader中使用光照衰减相关光照变量能正确赋值到对应的内置变量中，并且会帮我们编译Bass Pass中的所有变体

            struct v2f
            {
               float4 vertex : SV_POSITION;
               float3 color :COLOR;
               float3 worldNormal:NORMAL;
               float4 worldVertex:TEXCOORD0;
            };
             
            fixed4 _MainColor;
            fixed4 _SpecularColor;
            float  _SpecularNum;
             
             
            v2f vert (appdata_base v)
            {
                v2f f;
               //将模型空间下的顶点转换到裁剪空间下
               f.vertex = UnityObjectToClipPos(v.vertex);
               f.worldNormal=UnityObjectToWorldNormal(v.normal);
               f.worldVertex=mul(UNITY_MATRIX_M,v.vertex);
               return f;
               
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed3 worldNormal=normalize(i.worldNormal);
             
             #if  defined (_DIRECTIONAL_LIGHT)
             fixed3 lightDir=normalize(_WorldSpaceLightPos0);
             #else
             fixed3 lightDir=normalize(_WorldSpaceLightPos0-i.worldVertex);
             #endif
             
                fixed3 lambertColor=_LightColor0*_MainColor*max(0,dot(worldNormal,lightDir));
 
                fixed3 viewDir= normalize(WorldSpaceViewDir(i.worldVertex));
                               
                 //计算半角方向向量
                fixed3 halfDir=normalize(viewDir+lightDir);
             
                fixed3 phongSpecularColor=_LightColor0*_SpecularColor*pow(max(0, dot( halfDir,worldNormal)),_SpecularNum);
           
              
               //光照衰减值
               #if defined(_DIRECTIONAL_LIGHT)//平行光
                    fixed atten=1;
               #elif defined(_POINT_LIGHT)//点光源
              //将世界坐标系下原点转到光源空间下
               
                   fixed3 lightCoord=mul(unity_WorldToLight,i.worldVertex);
                   fixed atten=tex2D(_LightTexure0,dot(lightCoord,lightCoord).xx).UNITY_ATTEN_CHANNEL;
               #elif defined(_SPOT_LIGHT)//聚光灯
                   fixed4 lightCoord=mul(unity_WorldToLight,i.worldVertex);
                   fixed atten=(lightCoord.z>0)*
                   tex2D(_LightTexture0,lightCoord.xy/lightCoord.w+0.5).w*
                   tex2D(_LightTextureB0,dot(lightCoord,lightCoord).xx).UNITY_ATTEN_CHANNEL;
                   #else 
                     fixed atten=1;
               #endif
                //衰减值  与  Lambert和Specular颜色的和 进行乘法混合
                          
                return fixed4((lambertColor+phongSpecularColor)*atten,1);
             
            }
            ENDCG
        }
    }
}
