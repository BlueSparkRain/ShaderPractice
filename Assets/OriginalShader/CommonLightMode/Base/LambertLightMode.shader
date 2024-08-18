Shader "Unlit/MyUnlitShader/LambertLightMode"
{
    //Lambert光照模型：漫反射光照颜色=光源的颜色*材质的漫反射颜色*（表面某顶点法向量*标准化光源方向向量）
     //半Lambert光照模型：漫反射光照颜色=光源的颜色*材质的漫反射颜色*（（表面某顶点法向量*标准化光源方向向量）*0.5+0.5)

    Properties
    {
   
        _MainColor("Color",Color)= (1,1,1,1)
    }
    SubShader
    {
        Tags { "LightingMode"="ForwardBase" } //常用于不透明物体的基本渲染
       
        Pass//逐顶点着色器实现Lambert漫反射光照模型
        {
            CGPROGRAM
             #include "UnityCG.cginc"
             #include "Lighting.cginc"
             
            #pragma vertex vert
            #pragma fragment frag
           
            struct v2f
            {
                float4 vertex : SV_POSITION;
                float4 color :COLOR;
            };
     
            fixed4 _MainColor;
     
            v2f vert (appdata_base v)
            {
                v2f f;
               
               //将模型空间下的顶点转换到裁剪空间下
                f.vertex = UnityObjectToClipPos(v.vertex);
                //获取相对于世界坐标系下的法线信息
                fixed3 normalDir=UnityObjectToWorldNormal(v.normal);//法线信息一般直接就是单位向量
                //获取入射光方向信息
                 fixed3 lightDir=normalize(_WorldSpaceLightPos0) ;
                //获取环境光照颜色
                fixed4 lightColor=_LightColor0;
                
                fixed4 baseColor=_MainColor*lightColor*max(0,dot(normalDir, lightDir));
                //为了阴影处不是全黑，加上Lambert环境光颜色公共变量
                f.color=baseColor+UNITY_LIGHTMODEL_AMBIENT;
                return f;
               
            }

            fixed4 frag (v2f i) : SV_Target
            {
                return i.color;
            }
            ENDCG
        }

       
    }
}
