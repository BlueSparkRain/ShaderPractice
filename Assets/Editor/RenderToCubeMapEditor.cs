using System;
using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;

public class RenderToCubeMapEditor : EditorWindow
{
    private GameObject _obj;
    private Cubemap _cubeMap;
    [MenuItem("CubeMapGenerate/OpenWindow")]
    public static void OpenWindow()
    {
        RenderToCubeMapEditor window = EditorWindow.GetWindow<RenderToCubeMapEditor>("立方体纹理生成", false);
        window.Show();
    }

    private void OnGUI()
    {
        GUILayout.Label("关联目标位置的场景内物体");
        _obj= EditorGUILayout.ObjectField(_obj, typeof(GameObject), true) as GameObject;
        GUILayout.Label("关联需要生成纹理的cubmap资源(需勾选Readable)");
        _cubeMap=EditorGUILayout.ObjectField(_cubeMap, typeof(Cubemap), false) as Cubemap;
        if (GUILayout.Button("生成立方体纹理"))
        {
            if (_obj == null || _cubeMap == null)
            {
                EditorUtility.DisplayDialog("温馨提醒", "请先关联必须的资源对象", "我知道了");
                return;
            }

            GameObject tmpobj = new GameObject("tmpobj");
            tmpobj.transform.position = _obj.transform.position;
            Camera camera = tmpobj.AddComponent<Camera>();
            camera.RenderToCubemap(_cubeMap);
            DestroyImmediate(tmpobj);

        }
    }
}
