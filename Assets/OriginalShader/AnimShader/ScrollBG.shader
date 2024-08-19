Shader "Unlit/ScrollBG"
{  //滚动背景
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _ScrollU("ScrollU",Float)=0
        _ScrollV("ScrollV",Float)=0
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue"="Transparent" "IgnoreProjector"="True" }
        Pass
        {
            ZWrite Off
            Blend SrcAlpha OneMinusSrcAlpha
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
          
            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };
           float _ScrollU;
           float _ScrollV;
            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (appdata_base v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
             o.uv=v.texcoord;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
               float2 scrollUV=frac(i.uv+fixed2(_ScrollU*_Time.y,_ScrollV*_Time.y));
                return  tex2D(_MainTex,scrollUV);
            }
            ENDCG
        }
    }
}
