Shader "Unlit/MyUnlitShader/BlinnPhingLightMode"
{
     //Phong光照模型=环境光模型+Lambert（漫反射）光照模型 + BlinnPhong高光反射光照模型
    Properties
    {
   
         _MainColor("Color",Color)= (1,1,1,1)
         _SpecularColor("SpecularColor",COLOR)=(1,1,1,1)
        _SpecularNum("SpecularNum",Range(0,20))=0.5
    }
     SubShader//逐片元着色器实现Phong光照模型(效果比逐顶点更好)
    {
        Tags { "LightingMode"="ForwardBase" } //常用于不透明物体的基本渲染
       
        Pass
        {
            CGPROGRAM
             #include "UnityCG.cginc"
             #include "Lighting.cginc"
             
            #pragma vertex vert
            #pragma fragment frag
           
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
                fixed3 phongColor=UNITY_LIGHTMODEL_AMBIENT+lambertColor+phongSpecularColor;
                i.color=phongColor;
                return fixed4(i.color,1);
            }
            ENDCG
        }
    }
}