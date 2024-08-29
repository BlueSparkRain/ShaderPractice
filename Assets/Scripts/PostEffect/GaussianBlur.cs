using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GaussianBlur : PostEffectBase
{

    protected override void UpdateProperty()
    {
        base.UpdateProperty();
    }

    protected override void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        if (material != null)
        {
            RenderTexture buffer = RenderTexture.GetTemporary(source.width, source.height, 0);
            //��Ϊ��Ҫ������pass
        }
        else 
        {
        Graphics.Blit(source, destination);
        }
    }
}
