using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LHSControl : PostEffectBase
{
    //亮度计算：对图像的像素颜色进行乘法运算
    //最终颜色=原始颜色*亮度变量
    //饱和度计算：相对于灰度颜色进行插值
    //灰度值（亮度）L=0.2126*R+0.7152*G+0.0722*B
    //灰度颜色=（L，L，L）
    //最终颜色=lerp（灰度颜色，原始颜色，饱和度变量）
    //对比度计算：相对于中兴灰色进行插值
    //中性灰色=（0.5,0.5,0.5）
    //最终颜色=lerp（中性灰色，原始颜色，对比度变量）
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
