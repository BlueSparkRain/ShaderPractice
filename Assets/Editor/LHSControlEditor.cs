using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using UnityEditor.TerrainTools;
[CustomEditor(typeof(LHSControl))]
public class LHSControlEditor : Editor
{
    private LHSControl targetComponment;
    private void OnEnable()
    {
        targetComponment = (LHSControl)target;
    }

    public override void OnInspectorGUI()
    {
        EditorGUILayout.LabelField("��Ļ�������� ���Ͷ� �Աȶȵ���");
        targetComponment.Brightness = EditorGUILayout.Slider(new GUIContent("��Ļ����"), targetComponment.Brightness, 0, 5); 
        targetComponment.Saturation = EditorGUILayout.Slider(new GUIContent("��Ļ���Ͷ�"), targetComponment.Saturation, 0, 5);
        targetComponment.Contrast = EditorGUILayout.Slider(new GUIContent("��Ļ�Աȶ�"), targetComponment.Contrast, 0, 5);
    }
}
