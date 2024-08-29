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
            //�����������룬׼��һ��������
            RenderTexture buffer = RenderTexture.GetTemporary(rtW,rtH, 0);
            //˫���Թ��˽������ţ������ƽ��
            buffer.filterMode = FilterMode.Bilinear;
            //��Ϊ��Ҫ������pass ����ͼ������
            Graphics.Blit(source, buffer, material,0);//��һ��ˮƽ����˼���õ�color1
            Graphics.Blit(buffer, destination, material,1);//�ڶ�����ֱ����˼��� ��color1�����ϳ�color2
            //�ͷŻ�����
            RenderTexture.ReleaseTemporary(buffer);
        }
        else
            Graphics.Blit(source, destination);
        
    }
}
