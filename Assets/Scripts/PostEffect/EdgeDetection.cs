using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EdgeDetection :PostEffectBase
{
    public Color EdgeColor;

    protected override void UpdateProperty()
    {
        if (material != null)
        {
            material.SetColor("_EdgeColor", EdgeColor);
        }
    }
}
