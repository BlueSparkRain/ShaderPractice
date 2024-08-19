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
        //纹理流动速度
        _UVSpeed("UVSpeed",Float)=1
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue"="Transparent" "IgnoreProjector"="True" "DisableBatching" ="True" }
      
        Pass
        {
            Cull Off
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
            float _UVSpeed;
            float4 _MainTex_ST;
           
            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

           

            v2f vert (appdata_base v)
            {
                v2f o;
                float4 offset=fixed4(1,1,1,1);
                offset.x=sin(_Time*_WaveFrequency+v.vertex.z*_InvWaveLength)*_WaveAmplitude;
                offset.y=sin(_Time*_WaveFrequency+v.vertex.z*_InvWaveLength)*_WaveAmplitude;
                o.vertex = UnityObjectToClipPos(v.vertex+offset);
                o.uv=v.texcoord.xy*_MainTex_ST.xy+_MainTex_ST.zw;
                o.uv=o.uv+fixed2(0,_Time.y*_UVSpeed);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 color=tex2D(_MainTex,i.uv)*_Color;
                return  color;
              
            }
            ENDCG
        }
    }
}
