using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LHSControl : PostEffectBase
{
    //���ȼ��㣺��ͼ���������ɫ���г˷�����
    //������ɫ=ԭʼ��ɫ*���ȱ���
    //���Ͷȼ��㣺����ڻҶ���ɫ���в�ֵ
    //�Ҷ�ֵ�����ȣ�L=0.2126*R+0.7152*G+0.0722*B
    //�Ҷ���ɫ=��L��L��L��
    //������ɫ=lerp���Ҷ���ɫ��ԭʼ��ɫ�����Ͷȱ�����
    //�Աȶȼ��㣺��������˻�ɫ���в�ֵ
    //���Ի�ɫ=��0.5,0.5,0.5��
    //������ɫ=lerp�����Ի�ɫ��ԭʼ��ɫ���Աȶȱ�����
    // Start is called before the first frame update
    [Range(0,5)]
    public float Brightness = 1;
    [Range(0,5)]
    public float Saturation = 1;
    [Range(0,5)]
    public float Contrast = 1;

    protected override void UpdateProperty()
    {
        if (material != null)
        {
            material.SetFloat("_Brightness", Brightness);
            material.SetFloat("_Saturation", Saturation);
            material.SetFloat("_Contrast", Contrast);
        }
    }
}
