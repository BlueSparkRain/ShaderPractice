Shader "Unlit/RingDisslove"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _NoiseTex("NoiseTex",2D)="white" {}
        _TexSpeed("TexSpeed",vector)=(0,0,0,0)
        _CullOut("CullOut",Range(0,1))=0.5
        _MainColor("MainColor",COLOR)=(1,1,1,1)
        _ColorIntensity("ColorIntensity",Range(0,4))=1

    }
    SubShader
    {
           Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}
       
      
        Pass
        {
            ZWrite Off
            Blend SrcAlpha OneMinusSrcAlpha
            Cull Off
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
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            sampler2D   _NoiseTex;
            float4  _NoiseTex_ST;
            float4 _TexSpeed;
            float  _CullOut;
            float4 _MainColor;
            float  _ColorIntensity;
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
              
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
          {
           
                half grandient=tex2D(_MainTex,i.uv+_Time.y*_TexSpeed.xy).r;
                float noise= tex2D(_NoiseTex,i.uv+_Time.y*_TexSpeed.zw).r;
               clip(grandient-_CullOut-noise);
          
                return _MainColor* _ColorIntensity;
            }
            ENDCG
        }
    }
}
