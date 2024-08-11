using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RotateTest : MonoBehaviour
{
    public GameObject EulerG1;
    public GameObject RotateG1;
    public float xAngle;
    public float yAngle;
    public float zAngle;
    public float rotateSpeed = 1;
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        EulerG1.transform.rotation *= Quaternion.Euler(xAngle * rotateSpeed, yAngle, zAngle);
      
        RotateG1.transform.Rotate(xAngle * rotateSpeed, yAngle, zAngle);
    }
}
