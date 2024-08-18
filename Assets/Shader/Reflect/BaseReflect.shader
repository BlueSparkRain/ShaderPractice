Shader "Unlit/MyUnlitShader/Reflect/BaseReflect"
{
    Properties
    {
     _CubeMap("CubMap",Cube)=""{}
     _Reflectivity("Reflectivity",Range(0,1))=0.5
     
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" "Queue"="Geometry"}
       

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
         
            #include "UnityCG.cginc"
            #include  "Lighting.cginc"
            samplerCUBE _CubeMap;
            float _Reflectivity;

            struct v2f
            {
                float4 pos : SV_POSITION;
                float3 wPos:TEXCOORD0;
                float3 wNormal:NORMAL;
                float3 wRef:TEXCOORD1;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (appdata_base v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.wPos=mul(UNITY_MATRIX_M,v.vertex);
                o.wNormal=UnityObjectToWorldNormal(v.normal);
                fixed3 wViewDir=UnityWorldSpaceViewDir(o.wPos);
                o.wRef=reflect(-wViewDir,o.wNormal);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                //对立方体纹理进行采样
                fixed4 cubecolor=texCUBE(_CubeMap,i.wRef);
                return cubecolor*_Reflectivity;
            }
            ENDCG
        }
    }
}
