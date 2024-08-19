using System;
using Unity.VisualScripting;
using UnityEditor;
using UnityEngine;

[CustomEditor(typeof(GeTechTex))]
public class GeTechTexEditor :Editor
{
    private GeTechTex targetComponent;
    private void OnEnable()
    {
        targetComponent = (GeTechTex)target;
    }

    public override void OnInspectorGUI()
    {
        DrawDefaultInspector();
        if (GUILayout.Button("更新方格程序纹理"))
        {
            targetComponent.CreatRectTechTex();
        }
    }
}
