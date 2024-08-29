using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EdgeDetection :PostEffectBase
{
    public Color EdgeColor;
    public Color BackGroundColor;
    [Range(0,6)]
    public float EdgeWidth=1;
    [Range(0, 10)]
    public float ColorHDR = 1;
    [Range(0,1)]
    [Header("»­Ãæ²Ê¶È")]
    public float BackGroundExtend =1;

    protected override void UpdateProperty()
    {
        if (material != null)
        {
            material.SetColor("_EdgeColor", EdgeColor);
            material.SetColor(" _BackGroundColor", BackGroundColor);
            material.SetFloat("_EdgeWidth", EdgeWidth);
            material.SetFloat("_ColorHDR", ColorHDR);
            material.SetFloat("_BackGroundExtend",BackGroundExtend);
        }
    }
}
