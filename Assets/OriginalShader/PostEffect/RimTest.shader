Shader "Unlit/RimTest"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        //描边颜色
        _EdgeColor("EdgeColor",COLOR)=(0,0,0,0)
        //描边宽度（梯度差距）
        _EdgeWidth("EdgeWidth",Range(0,6))=1
        //描边亮度
        _ColorHDR("ColorHDR",Range(0,10))=1
        //背景颜色彩度
        _BackGroundExtend("_BackGroundExtend",Range(0,1))=0
        //背景颜色
        _BackGroundColor("_BackGroundColor",COLOR)=(1,1,1,1)
        
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
         Pass
        {
            ZTest Always 
            ZWrite Off 
            Cull Off
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
          
            #include "UnityCG.cginc"

            struct v2f
            {
                float2 uv[9] : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float4 _MainTex_TexelSize;
            float4 _EdgeColor;
            float _EdgeWidth;
            float _ColorHDR;
            fixed _BackGroundExtend;
            fixed4 _BackGroundColor;
            v2f vert (appdata_base v)
            {
                v2f o;
                half2 uv = v.texcoord;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv[0]=uv+ _MainTex_TexelSize.xy* half2(-1,-1);
                o.uv[1]=uv+ _MainTex_TexelSize.xy* half2(0,-1);
                o.uv[2]=uv+ _MainTex_TexelSize.xy* half2(1,-1);
                o.uv[3]=uv+ _MainTex_TexelSize.xy* half2(-1,0);
                o.uv[4]=uv+ _MainTex_TexelSize.xy* half2(0,0);
                o.uv[5]=uv+ _MainTex_TexelSize.xy* half2(1,0);
                o.uv[6]=uv+ _MainTex_TexelSize.xy* half2(-1,1);
                o.uv[7]=uv+ _MainTex_TexelSize.xy* half2(0,1);
                o.uv[8]=uv+ _MainTex_TexelSize.xy* half2(1,1);
                return o;
            }

            //计算像素颜色的灰度值
            fixed calcLuminance(fixed4 color)
            {
            return 0.2126*color.r+0.7152*color.g+0.0722*color.b;
            }

            //Sobel算子相关的卷积计算
            half Sobel(v2f o)
            {
            //Sobel算子对应的两个卷积核
            half Gx[9]={-1 ,-2 , -1,
                         0 , 0 , 0,
                         1 , 2 , 1};

            half Gy[9]={-1 ,0, 1,
                         -2 , 0 , 2,
                         -1 , 0 , 1};
             half L;//灰度值
             half edgeX=0;//水平方向的梯度值
             half edgeY=0;//竖直方向的梯度值

             for (int i = 0; i < 9; i++)
             {
               //采样颜色后 计算灰度值并记录
               L =  calcLuminance(tex2D( _MainTex,o.uv[i])) * _EdgeWidth;
               edgeX+=L * Gx[i];
               edgeY+=L * Gy[i];
             }
             //得到该像素最终的梯度值
             half G= abs(edgeX) + abs(edgeY);
             return G;
            }
            fixed4 frag (v2f i) : SV_Target
            {
              //计算梯度值
              half edge= Sobel(i);
              //原图上描边
             fixed4 edgeColor =lerp(tex2D(_MainTex,i.uv[4]),_EdgeColor* _ColorHDR,edge);
             //纯色上描边
             fixed4 onlyEdgeColor= lerp(_BackGroundColor,_EdgeColor* _ColorHDR,edge);
             //原色or纯色
             return lerp(edgeColor,onlyEdgeColor, _BackGroundExtend);
            }


            ENDCG
        }
    }
    Fallback off
}
