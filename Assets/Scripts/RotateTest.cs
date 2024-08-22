using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class RotateTest : MonoBehaviour
{
    public float xAngle;
    public float yAngle;
    public float zAngle;
    public float rotateSpeed = 1;
    public GameObject MaskTwoSidess;
   

    void Update()
    {
      // EulerG1.transform.rotation *= Quaternion.Euler(xAngle * rotateSpeed, yAngle, zAngle);
      //  RotateG1.transform.Rotate(xAngle * rotateSpeed, yAngle, zAngle);
        MaskTwoSidess.transform.Rotate(xAngle, yAngle*rotateSpeed, zAngle);
    }
}
