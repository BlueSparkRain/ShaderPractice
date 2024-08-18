Shader "Unlit/Glass"
{
      Properties
    {
        _MainTex("MainTex",2D)=""{}
     _CubeMap("CubMap",Cube)=""{}
     //折射程度 0代表完全反射 1代表完全折射（透明）
     _RefractAmounnt("RefractAmounnt",Range(0,1))=1
     
    }
    SubShader
    {
        //为了让玻璃物体滞后渲染，这里使用Transparent渲染队列，但是其实仍是不透明物体
        Tags { "RenderType"="Opaque" "Queue"="Transparent"}
       
        //捕获当前屏幕上内容，并储存到默认的渲染纹理变量中
        GrabPass
        {}
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
         
            #include "UnityCG.cginc"
            #include  "Lighting.cginc"
           
            struct v2f
            {
                float4 pos : SV_POSITION;
                //用于存储从屏幕图像中采样的坐标
                float4 grabPos:TEXCOORD0;
                float2 uv:TEXCOORD1;
                float3 wRef:TEXCOORD2;
            };
            
            samplerCUBE _CubeMap;
            float _RefractAmounnt;
            sampler2D _MainTex;
            float4 _MainTex_ST;
            //Grabpass默认存储的纹理变量：_GrabTexture
            sampler2D _GrabTexture;

            v2f vert (appdata_base v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                //屏幕坐标转换相关
                o.grabPos=ComputeGrabScreenPos(o.pos);
                 o.uv=v.texcoord.xy*_MainTex_ST.xy+_MainTex_ST.zw;
                fixed3 wNormal=UnityObjectToWorldNormal(v.normal);
                fixed3 wPos=mul(UNITY_MATRIX_M,v.vertex);
                fixed3 wViewDir=UnityWorldSpaceViewDir(wPos);
                o.wRef=reflect(-wViewDir,wNormal);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                //对立方体纹理进行采样
                fixed4 reflectColor=texCUBE(_CubeMap,i.wRef)*tex2D(_MainTex,i.uv);
                //折射效果：在采样之前对屏幕xy进行偏移
                float2 offset=1-_RefractAmounnt;
                i.grabPos.xy=i.grabPos-offset/10;
                //透视除法，将屏幕坐标转换到0~1范围内
                float2 screenUV=i.grabPos.xy/i.grabPos.w;
                //从捕获的屏幕纹理中采样
                fixed4 screenTex=tex2D(_GrabTexture,screenUV);
                float4 color=reflectColor*(1-_RefractAmounnt)+screenTex*_RefractAmounnt;
                return color;
            }
            ENDCG
        }
    }
}
