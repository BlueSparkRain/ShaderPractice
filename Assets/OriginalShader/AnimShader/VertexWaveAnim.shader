Shader "Unlit/VertexWaveAnim"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Color("Color",Color)=(1,1,1,1)
        //波动幅度
        _WaveAmplitude("WaveAmplitude",Float)=1
        //波动频率
        _WaveFrequency("WaveFrequency",Float)=1
        //波长的倒数
        _InvWaveLength("InvWaveLength",Float)=1
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue"="Transparent" "IgnoreProjector"="True" "DisableBatching" ="True" }
      
        Pass
        {
            ZWrite Off
            Blend SrcAlpha OneMinusSrcAlpha
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
         
            #include "UnityCG.cginc"
            
             float4 _Color;
             float _WaveAmplitude;
             float _WaveFrequency;
             float _InvWaveLength;
             sampler2D _MainTex;
            float4 _MainTex_ST;
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

           

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
               
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
              
            }
            ENDCG
        }
    }
}
