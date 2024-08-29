Shader "Unlit/GaussianBlur"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        //���ڰ������ô��� ��֮��Ķ��pass���ж�����ʹ�õĴ���
        CGINCLUDE
         
        #include "UnityCG.cginc"
         sampler2D _MainTex;
         //���� x=1/�� y=1/��
         half4 _MainTex_TexelSize;

           struct v2f
           {
                //5�����ص�uv����ƫ��
                half2 uv[5] : TEXCOORD0;
                //�ü��ռ��µĶ�������
                float4 vertex : SV_POSITION;
           };

          //ˮƽ�����  ������ɫ������
           v2f vertBlurHorizontal(appdata_base v)
           {
           v2f o;
           o.vertex=UnityObjectToClipPos(v.vertex);
           //5�����ص�uvƫ��
           half2 uv = v.texcoord;

           o.uv[0]=uv;
           o.uv[1]=uv + half2(_MainTex_TexelSize.x*1,0);
           o.uv[2]=uv - half2(_MainTex_TexelSize.x*1,0);
           o.uv[3]=uv + half2(_MainTex_TexelSize.x*2,0);
           o.uv[4]=uv - half2(_MainTex_TexelSize.x*2,0);

           return o;
           }

           //��ֱ�����  ������ɫ������
            v2f vertBlurVertical(appdata_base v)
           {
           v2f o;
           o.vertex=UnityObjectToClipPos(v.vertex);
           //5�����ص�uvƫ��
           half2 uv = v.texcoord;

           o.uv[0]=uv;
           o.uv[1]=uv + half2(0,_MainTex_TexelSize.x*1);
           o.uv[2]=uv - half2(0,_MainTex_TexelSize.x*1);
           o.uv[3]=uv + half2(0,_MainTex_TexelSize.x*2);
           o.uv[4]=uv - half2(0,_MainTex_TexelSize.x*2);

           return o;
           }

           //ƬԪ��ɫ������
           fixed4 fragBlur(v2f i): SV_TARGET
           {
           //������㣬��������а���ƫ��λ����ֻ��3����
           float weight[3]={0,4026,0.2442,0.0545};
           //�ȼ��㵱ǰ���ص�
           fixed3 sum = tex2D(_MainTex,i.uv[0]).rgb* weight[0];


           //��������ƫ��1��2����λ�� ��λ��� ���ۼ�
           for (int it = 1; it < 3; it++)
           {
          //�������ǵ������д洢������uvƫ�Ʒֱ���
          // index:   0  1  2  3  4
          // x��yƫ��:0  1 -1  2  -2

            //Ҫ����Ԫ�����
            sum += tex2D(_MainTex,i.uv[it*2-1]).rgb * weight[it];
            //����Ԫ�����
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
