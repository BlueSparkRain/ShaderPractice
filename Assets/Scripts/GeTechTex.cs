using System;
using System.Collections;
using System.Collections.Generic;
using Unity.VisualScripting;
using UnityEngine;

//通过C# 动态生成程序纹理
public class GeTechTex : MonoBehaviour
{
    public int tileWidth=256;
   
    public int tileHeight=256;
    public int tileCount = 8;
    public Color Color1 = Color.white;
    public Color Color2 = Color.blue;

    private void Start()
    {
        CreatRectTechTex();
    }

    public void CreatRectTechTex()
    {
        Texture2D texture = new Texture2D(tileWidth, tileHeight);
        for (int y = 0; y < tileHeight; y++)
        {
            for (int x = 0; x < tileWidth; x++)
            {
                if (x/(tileWidth / tileCount) % 2 == y/(tileHeight / tileCount) % 2)
                    texture.SetPixel(x,y,Color1);
                else
                    texture.SetPixel(x,y,Color2);
                

            }
        }
        texture.Apply();

        Renderer renderer = GetComponent<Renderer>();
        renderer.sharedMaterial.mainTexture = texture;
    }
}
