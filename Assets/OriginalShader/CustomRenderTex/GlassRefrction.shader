Shader "Unlit/GlassRefrction"
{
      Properties
    {
        //主纹理
        _MainTex("MainTex",2D)=""{}
        //法线纹理
        _BumpMap("BumpMap", 2D) = ""{}
        //立方体纹理
       _CubeMap("CubMap",Cube)=""{}
       //折射程度 0代表完全反射 1代表完全折射（透明）
       _RefractAmount("RefractAmounnt",Range(0,1))=1
        //控制折射扭曲程度
        _Distortion("Distortion",Range(0,10))=0
     
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
                float4 uv:TEXCOORD1;
         
                  //代表我们切线空间到世界空间的 变换矩阵的3行
                float4 TtoW0:TEXCOORD3;
                float4 TtoW1:TEXCOORD4;
                float4 TtoW2:TEXCOORD5;
            };
            
            samplerCUBE _CubeMap;
            float _RefractAmount;
            sampler2D _MainTex;
            float4 _MainTex_ST;
             sampler2D _BumpMap;//法线纹理
            float4 _BumpMap_ST;//法线纹理的缩放和平移
            //Grabpass默认存储的纹理变量：_GrabTexture
            sampler2D _GrabTexture;
            float  _Distortion;

            v2f vert (appdata_full v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                //屏幕坐标转换相关
                o.grabPos=ComputeGrabScreenPos(o.pos);
                //主纹理UV坐标计算
                 o.uv.xy=v.texcoord.xy*_MainTex_ST.xy+_MainTex_ST.zw;
                //法线纹理UV坐标计算
                 o.uv.zw = v.texcoord.xy * _BumpMap_ST.xy + _BumpMap_ST.zw;
                //计算反射光向量
                fixed3 wNormal=UnityObjectToWorldNormal(v.normal);
                fixed3 wPos=mul(UNITY_MATRIX_M,v.vertex);
                
                //得到世界空间下切线向量
                float3 worldTangent = UnityObjectToWorldDir(v.tangent);
                 //计算副切线 计算叉乘结果后 垂直与切线和法线的向量有两条 通过乘以 切线当中的w（正负代表正反面），就可以确定是哪一条
                float3 worldBinormal = cross(normalize(worldTangent), normalize(wNormal)) * v.tangent.w;
                 //这个就是我们 切线空间到世界空间的 转换矩阵
                o.TtoW0 = float4(worldTangent.x, worldBinormal.x,  wNormal.x, wPos.x);
                o.TtoW1 = float4(worldTangent.y, worldBinormal.y,  wNormal.y, wPos.y);
                o.TtoW2 = float4(worldTangent.z, worldBinormal.z,  wNormal.z, wPos.z);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                 //对颜色纹理进行采样
                fixed4 mainTex=tex2D(_MainTex,i.uv.xy);
                 //通过纹理采样函数 取出法线纹理贴图当中的数据
                float4 packedNormal = tex2D(_BumpMap, i.uv.zw);
                //将取出来的法线数据 进行逆运算并且进行解压缩的运算，最终得到切线空间下的法线数据
                float3 tangentNormal = UnpackNormal(packedNormal);
                //把计算完毕后的切线空间下的法线转换到世界空间下
                float3 wNormal = float3(dot(i.TtoW0.xyz, tangentNormal), dot(i.TtoW1.xyz, tangentNormal), dot(i.TtoW2.xyz, tangentNormal));
                //世界空间下视角方向
                float3 wPos = float3(i.TtoW0.w, i.TtoW1.w, i.TtoW2.w);
                fixed3 wViewDir = normalize(UnityWorldSpaceViewDir(wPos));
                //计算反射向量
                float3 reflDir=reflect(-wViewDir,wNormal);
                //对立方体纹理进行采样
                fixed4 reflectColor=texCUBE(_CubeMap,reflDir)*mainTex;
                
                //折射效果：代表光线经过法线扭曲扰动后的偏移程度，确定光线折射的方向和强度
                float2 offset=tangentNormal.xy*_Distortion;
                //用偏移量和屏幕空间深度值相乘，模拟真实折射效果
                i.grabPos.xy=i.grabPos.xy+offset*i.grabPos.z;
                //透视除法，将屏幕坐标转换到0~1范围内
                float2 screenUV=i.grabPos.xy/i.grabPos.w;
                //从捕获的屏幕纹理中采样
                fixed4 screenTex=tex2D(_GrabTexture,screenUV);
                float4 color=reflectColor*(1-_RefractAmount)+screenTex*_RefractAmount;
                return color;
            }
            ENDCG
        }
    }
}
