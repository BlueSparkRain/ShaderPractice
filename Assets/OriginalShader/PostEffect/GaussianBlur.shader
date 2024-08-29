Shader "Unlit/GaussianBlur"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        //用于包裹共用代码 在之后的多个pass当中都可以使用的代码
        CGINCLUDE
         
        #include "UnityCG.cginc"
         sampler2D _MainTex;
         //纹素 x=1/宽 y=1/高
         half4 _MainTex_TexelSize;

           struct v2f
           {
                //5个像素的uv坐标偏移
                half2 uv[5] : TEXCOORD0;
                //裁剪空间下的顶点坐标
                float4 vertex : SV_POSITION;
           };

          //水平方向的  顶点着色器函数
           v2f vertBlurHorizontal(appdata_base v)
           {
           v2f o;
           o.vertex=UnityObjectToClipPos(v.vertex);
           //5个像素的uv偏移
           half2 uv = v.texcoord;

           o.uv[0]=uv;
           o.uv[1]=uv + half2(_MainTex_TexelSize.x*1,0);
           o.uv[2]=uv - half2(_MainTex_TexelSize.x*1,0);
           o.uv[3]=uv + half2(_MainTex_TexelSize.x*2,0);
           o.uv[4]=uv - half2(_MainTex_TexelSize.x*2,0);

           return o;
           }

           //竖直方向的  顶点着色器函数
            v2f vertBlurVertical(appdata_base v)
           {
           v2f o;
           o.vertex=UnityObjectToClipPos(v.vertex);
           //5个像素的uv偏移
           half2 uv = v.texcoord;

           o.uv[0]=uv;
           o.uv[1]=uv + half2(0,_MainTex_TexelSize.x*1);
           o.uv[2]=uv - half2(0,_MainTex_TexelSize.x*1);
           o.uv[3]=uv + half2(0,_MainTex_TexelSize.x*2);
           o.uv[4]=uv - half2(0,_MainTex_TexelSize.x*2);

           return o;
           }

           //片元着色器函数
           fixed4 fragBlur(v2f i): SV_TARGET
           {
           //卷积运算，卷积核其中按照偏移位数，只有3个数
           float weight[3]={0,4026,0.2442,0.0545};
           //先计算当前像素点
           fixed3 sum = tex2D(_MainTex,i.uv[0]).rgb* weight[0];


           //计算左右偏移1和2个单位的 对位相乘 再累加
           for (int it = 1; it < 3; it++)
           {
          //由于我们的数组中存储的像素uv偏移分别是
          // index:   0  1  2  3  4
          // x或y偏移:0  1 -1  2  -2

            //要和右元素相乘
            sum += tex2D(_MainTex,i.uv[it*2-1]).rgb * weight[it];
            //和左元素相乘
            sum += tex2D(_MainTex,i.uv[it*2]).rgb * weight[it];
           }

           return fixed(sum,1);


       }

        ENDCG

        Tags { "RenderType"="Opaque" }
 
         ZTest Always
         ZWrite Off
         Cull Off
        Pass
        {
            CGPROGRAM
            #pragma vertex vertBlurHorizontal
            #pragma fragment fragBlur
        
           
            ENDCG
        }
        
        Pass
        {
            CGPROGRAM
            #pragma vertex vertBlurVertical
            #pragma fragment fragBlur
        
           
            ENDCG
        }
    }
    Fallback off
}
