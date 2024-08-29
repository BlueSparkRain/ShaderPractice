using AmplifyShaderEditor;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GaussianBlur : PostEffectBase
{
    [Range(1,8)]
    public int downSample = 1;
   

    protected override void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        if (material != null)
        {
            int rtW= source.width / downSample;
            int rtH= source.height / downSample;
            //缓存区的申请，准备一个缓冲区
            RenderTexture buffer = RenderTexture.GetTemporary(rtW,rtH, 0);
            //双线性过滤进行缩放，结果更平滑
            buffer.filterMode = FilterMode.Bilinear;
            //因为需要用两个pass 处理图像两次
            Graphics.Blit(source, buffer, material,0);//第一次水平卷积核计算得到color1
            Graphics.Blit(buffer, destination, material,1);//第二次竖直卷积核计算 在color1基础上乘color2
            //释放缓存区
            RenderTexture.ReleaseTemporary(buffer);
        }
        else
            Graphics.Blit(source, destination);
        
    }
}
