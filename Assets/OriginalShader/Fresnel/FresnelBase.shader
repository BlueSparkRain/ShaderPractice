Shader "Unlit/MyUnlitShader/Fresnel/FresnelBase"
{
     Properties
    {
        //立方体纹理
     _CubeMap("CubMap",Cube)=""{}
       // Fresnel反射中，介质对应的反射率
     _FresnelScale("FresnelScale",Range(0,1))=1
     
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
            float _FresnelScale;

            struct v2f
            {
                float4 pos : SV_POSITION;
                float3 wViewDir:TEXCOORD0;
                float3 wNormal:NORMAL;
                float3 wRefl:TEXCOORD1;
            };

           
            v2f vert (appdata_base v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.wNormal=UnityObjectToWorldNormal(v.normal);
                fixed3 wPos=mul(UNITY_MATRIX_M,v.vertex);
                //UnityWorldSpaceViewDir其内部是摄像机pos-顶点pos，计算反射向量时viewDir需反向
                o.wViewDir=UnityWorldSpaceViewDir(wPos);
                o.wRefl=reflect(-o.wViewDir,o.wNormal);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                //对立方体纹理进行采样
                fixed4 cubecolor=texCUBE(_CubeMap,i.wRefl);
                //利用schlick近似等式计算Fresnel反射率
                fixed fresnel=_FresnelScale+(1-_FresnelScale)*pow(1-dot(normalize(i.wNormal),normalize(i.wViewDir)),5);
                return cubecolor*fresnel;
            }
            ENDCG
        }
    }
}
