Shader "Unlit/Mirror"
{
    //镜面效果：纹理反向操作
   Properties
    {
        _MainTex ("Texture", 2D) = "white"{}
    }
    SubShader
    {
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            #include "Lighting.cginc"
            
            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
              
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            
            v2f vert ( appdata_base v)
            {
                v2f fData;
                fData.vertex = UnityObjectToClipPos(v.vertex);
                fData.uv=v.texcoord.xy*_MainTex_ST.xy+_MainTex_ST.zw;
                //在x轴方向反向
                fData.uv.x=1-fData.uv.x;
                return fData;
            }

            fixed4 frag (v2f i) : SV_Target
            {
               fixed4 color=tex2D(_MainTex,i.uv);
              
                return color;
            }
            ENDCG
        }
    }
Fallback "Diffuse"
}
