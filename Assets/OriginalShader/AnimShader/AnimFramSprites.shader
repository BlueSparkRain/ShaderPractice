Shader "Unlit/AnimFramSprites"
{//帧动画
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        //图集行列
        _Rows("Rows", int) = 8
        _Columns("Columns", int) = 8
        //切换动画速度变量
        _Speed("Speed", float) = 1
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

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float _Rows;
            float _Columns;
            float _Speed;

            v2f vert (appdata_base v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.texcoord;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                //得到当前帧 利用时间变量计算
                float frameIndex = floor(_Time.y * _Speed) % (_Rows * _Columns);
                //小格子（小图片）采样时的起始位置计算
                //除以对应的行和列 目的是将行列值 转换到 0~1的坐标范围内
                //1 - (floor(frameIndex / _Columns) + 1)/_Rows
                //  +1 是因为把格子左上角转换为格子左下角
                //  1- 因为UV坐标采样时从左下角进行采样的
                float2 frameUV = float2(frameIndex % _Columns / _Columns, 1 - (floor(frameIndex / _Columns) + 1)/_Rows);
                //得到uv缩放比例 相当于从0~1大图 隐射到一个 0~1/n的一个小图中
                float2 size = float2(1/_Columns, 1/_Rows);
                //计算最终的uv采样坐标信息
                //*size 相当于把0~1范围 缩放到了 0~1/8范围
                //+frameUV 相当于把起始的采样位置 移动到了 对应帧小格子的起始位置
                float2 uv = i.uv * size + frameUV;
                //最终采样颜色
                return tex2D(_MainTex, uv);
            }
            ENDCG
        }
    }
}
