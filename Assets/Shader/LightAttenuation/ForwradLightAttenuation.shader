Shader "Unlit/ForwradLightAttenuation"
{
    //前向渲染路径中处理点光源和聚光源,支持光照和（不透明物体的）阴影衰减
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
             #include "AutoLight.cginc"//内含计算阴影所需的宏
            #pragma vertex vert
            #pragma fragment frag
             
               #pragma multi_compile_fwdbase
            //确保在shader中使用光照衰减相关光照变量能正确赋值到对应的内置变量中，并且会帮我们编译Bass Pass中的所有变体

            struct v2f
            {
               float4 pos : SV_POSITION;
               float3 worldNormal:NORMAL;
               float4 wPos:TEXCOORD0;
               //阴影坐标宏，主要用于储存阴影纹理坐标
               SHADOW_COORDS(1)//1表示下一个可用的差值寄存器的索引值,前面有几个texcoord就填几
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
               f.pos = UnityObjectToClipPos(v.vertex);
               f.worldNormal=UnityObjectToWorldNormal(v.normal);
               f.wPos=mul(UNITY_MATRIX_M,v.vertex);
               //转换阴影宏，计算阴影映射纹理坐标，内部将顶点进行坐标转换计算后存入SHADOW_COORDS中
               TRANSFER_SHADOW(f);
               return f;
               
            }

            fixed4 frag (v2f i) : SV_Target
            {
                
                fixed3 lambertColor=GetLambertLMode(i.worldNormal);
                fixed3 phongSpecularColor=GetBlinnPhongSepecularLMode(i.worldNormal,i.wPos);
                //阴影衰减值

                //利用灯光和阴影衰减计算宏
                UNITY_LIGHT_ATTENUATION(atten,i,i.wPos)
                fixed3 phongColor=UNITY_LIGHTMODEL_AMBIENT+(lambertColor+phongSpecularColor)*atten;
               
                return fixed4(phongColor,1);
            }
            ENDCG
        }

        Pass//Additional Pass 附加渲染通道
        {
             Tags { "LightMode"="ForwardAdd" } 
             Blend One One//混合叠加（类线性减淡效果）
             
            CGPROGRAM
             #include "UnityCG.cginc"
             #include "Lighting.cginc"
             #include  "AutoLight.cginc"
             #pragma vertex vert
             #pragma fragment frag
        
            #pragma  multi_compile_fwdadd_fullshadows
           

            struct v2f
            {
               fixed4 pos : SV_POSITION;
    
               float3 worldNormal:NORMAL;
               fixed4 wPos:TEXCOORD0;
               SHADOW_COORDS(2)
            };
             
            fixed4 _MainColor;
            fixed4 _SpecularColor;
            float  _SpecularNum;
             
             
            v2f vert (appdata_base v)
            {
                v2f f;
               //将模型空间下的顶点转换到裁剪空间下
               f.pos = UnityObjectToClipPos(v.vertex);
               f.worldNormal=UnityObjectToWorldNormal(v.normal);
               f.wPos=mul(UNITY_MATRIX_M,v.vertex);
               TRANSFER_SHADOW(f);
               return f;
               
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed3 worldNormal=normalize(i.worldNormal);
             
             #if  defined (_DIRECTIONAL_LIGHT)
             fixed3 lightDir=normalize(_WorldSpaceLightPos0);
             #else
             fixed3 lightDir=normalize(_WorldSpaceLightPos0-i.wPos);
             #endif
             
                fixed3 lambertColor=_LightColor0*_MainColor*max(0,dot(worldNormal,lightDir));
 
                fixed3 viewDir= normalize(WorldSpaceViewDir(i.wPos));
                               
                 //计算半角方向向量
                fixed3 halfDir=normalize(viewDir+lightDir);
             
                fixed3 phongSpecularColor=_LightColor0*_SpecularColor*pow(max(0, dot( halfDir,worldNormal)),_SpecularNum);
                                
                //利用灯光和阴影衰减计算宏,其内部已经区分了不同的光源类型,并且已经乘上了阴影衰减值
                UNITY_LIGHT_ATTENUATION(atten,i,i.wPos.xyz)
                return fixed4((lambertColor+phongSpecularColor)*atten,1);
             
            }
            ENDCG

        }
  
//        Pass//实现物体产生阴影投射的pass,注意：该pass其实和FallBack的Specular作用是近似的，建议无需手写直接使用FallBack
//        {
//             Tags {"LightMode"="ShadowCaster"}
//      
//              CGPROGRAM
//              #pragma  vertex vert
//               #pragma  fragment frag
//              
//              #pragma  multi_compile_shadowcaster
//              //生成多个着色器变体用于支持不同类型的阴影，确保在所有阴影投射模式下正确渲染
//               #include  "UnityCG.cginc"
//
//              struct  v2f
//              {
//             //顶点到片元着色器阴影投射结构体数据宏
//             //定义了一些标准的成员变量，在解饿构体中使用，主要用于在阴影投射路径中传递顶点数据到片元着色器
//               V2F_SHADOW_CASTER;
//              };
//              
//              v2f vert (appdata_base v)
//            {
//             v2f fData;
//               //转移阴影投射器法线偏移宏
//               //用于在顶点着色器中计算和传递阴影投射所需的变量
//               //1.将对象空间的顶点位置转换为裁剪空间的位置
//               //2.考虑法线偏移，以减轻阴影失真问题。尤其是处理自阴影时
//               //3.传递顶点的投射空间位置用于后续阴影计算
//               //主要在顶点着色器中使用
//               TRANSFER_SHADOW_CASTER_NORMALOFFSET(fData)
//               return  fData;
//            }
//
//            fixed4 frag (v2f i) : SV_Target
//            {
//             //阴影投射片元宏
//             //将深度值写入阴影映射纹理中
//             //主要在片元着色器中使用
//             SHADOW_CASTER_FRAGMENT(i);
//            
//            }
//              ENDCG
//         }
     
    }
    Fallback "Specular"
}
