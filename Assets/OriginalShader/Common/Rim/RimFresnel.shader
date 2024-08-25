// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Unlit/RimFresnel"
{
    Properties
    {
        _MianTex("MainTex",2D)="white"{}
        _Emisse("Emisse",float)=1
        _MainColor("MainColor",Color)=(1,1,1,1)
        _FresnelPower("FresnelPower",float)=1
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" }
        LOD 100
      
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
                float3 normal:NORMAL;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float3 wPos:TEXCOORD2;
                float3 wNormal:TEXCOORD1;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float4 _MainColor;
            float  _Emisse;
            float _FresnelPower;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.wPos=mul(unity_ObjectToWorld,v.vertex);
                o.wNormal= normalize(UnityObjectToWorldNormal(v.normal));
             
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {               
              //  fixed3 color = tex2D(_MainTex, i.uv).xyz* _Emisse;
                float3 viewDir=normalize(UnityWorldToViewPos(i.wPos));
             
                float alpha= saturate((1- pow( saturate(dot(viewDir,i.wNormal)),_FresnelPower)));
                // float alpha= saturate( pow( (1- saturate(dot(viewDir,i.wNormal))),_FresnelPower));
                float3 color= _MainColor.xyz* _Emisse;
                fixed4 mainColor= half4(color,alpha);
                return mainColor;
       
            }
            ENDCG
        }
    }
}
