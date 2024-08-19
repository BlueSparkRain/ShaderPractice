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
        if (GUILayout.Button("更新程序纹理"))
        {
            targetComponent.CreatTechTex();
        }
    }
}
