using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
[RequireComponent(typeof(Camera))]
public class PostEffectBase : MonoBehaviour
{
    //��Ļ����Ч����ʹ�õ�Shader
    public Shader shader;
    //һ�����ڶ�̬���������Ĳ����� �Ͳ����ٹ������ֶ�������
    private Material _material;

    protected virtual void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        //�ж�����������Ƿ�Ϊ�� �����Ϊ�� ��֤�����shader������������Ļ����Ч��
        if (material != null)
            Graphics.Blit(source, destination, material);
        else//���Ϊ�� �Ͳ��ô������Ч���� ֱ����ʾԭ����Ϳ�����
            Graphics.Blit(source, destination);
    }

    protected Material material
    {
        get
        {
            //���shader û�� �����е��ǲ�֧�ֵ�ǰƽ̨
            if (shader == null || !shader.isSupported)
                return null;
            else
            {
                //����ÿ�ε������Զ�ȥnew������
                //���֮ǰnew���ˣ�����shaderҲû�б仯
                //�ǾͲ���new�� ֱ�ӷ���ʹ�ü���
                if (_material != null && _material.shader == shader)
                    return _material;
                //���ǲ������ǿյ� ����shader�仯�� �Ż���������߼�

                //��֧�ֵ�shader��̬����һ�������� ������Ⱦ
                _material = new Material(shader);
                //��ϣ�������򱻱������� ������Ǽ�һ����ʶ
                _material.hideFlags = HideFlags.DontSave;
                return _material;
            }
        }
    }
}