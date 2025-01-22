using System.Collections;
using System.Collections.Generic;
using UnityEngine.UI;
using UnityEngine;

public class ProgressBar : MonoBehaviour
{
    public float max;
    public float cur;

    public Image mask;


    private void Update()
    {
        
    }

    void GetCurrentFill()
    {
        float fillamount = cur / max;
        mask.fillAmount = fillamount;
    }
}
