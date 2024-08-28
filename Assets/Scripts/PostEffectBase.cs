using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
[RequireComponent(typeof(Camera))]
public class PostEffectBase : MonoBehaviour
{
    //屏幕后处理效果会使用的Shader
    public Shader shader;
    //一个用于动态创建出来的材质球 就不用再工程中手动创建了
    private Material _material;

    protected virtual void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        //判断这个材质球是否为空 如果不为空 就证明这个shader能用来处理屏幕后处理效果
        if (material != null)
            Graphics.Blit(source, destination, material);
        else//如果为空 就不用处理后处理效果了 直接显示原画面就可以了
            Graphics.Blit(source, destination);
    }

    protected Material material
    {
        get
        {
            //如果shader 没有 或者有但是不支持当前平台
            if (shader == null || !shader.isSupported)
                return null;
            else
            {
                //避免每次调用属性都去new材质球
                //如果之前new过了，并且shader也没有变化
                //那就不用new了 直接返回使用即可
                if (_material != null && _material.shader == shader)
                    return _material;
                //除非材质球是空的 或者shader变化了 才会走下面的逻辑

                //用支持的shader动态创建一个材质球 用于渲染
                _material = new Material(shader);
                //不希望材质球被保存下来 因此我们家一个标识
                _material.hideFlags = HideFlags.DontSave;
                return _material;
            }
        }
    }
}