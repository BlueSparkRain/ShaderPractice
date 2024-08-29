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
        EditorGUILayout.LabelField("屏幕后处理：亮度 饱和度 对比度调整");
        targetComponment.Brightness = EditorGUILayout.Slider(new GUIContent("屏幕亮度"), targetComponment.Brightness, 0, 5); 
        targetComponment.Saturation = EditorGUILayout.Slider(new GUIContent("屏幕饱和度"), targetComponment.Saturation, 0, 5);
        targetComponment.Contrast = EditorGUILayout.Slider(new GUIContent("屏幕对比度"), targetComponment.Contrast, 0, 5);
    }
}
