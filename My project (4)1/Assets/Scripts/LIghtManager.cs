using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LIghtManager : MonoBehaviour
{
    private Color armor = new Color(2.31f, 1.57f, 0.6f);
    private Color oxy = new Color(0, 0, 0);
    private Color shark = new Color();
    private Color idle = Color.white;

    [SerializeField] GameObject sharkGameObject;
    [SerializeField] public float Timer;
    [SerializeField] public float Time_for_shock;

    private float time = 0f;

    

    private void Awake()
    {
        SharkBehaviour sharkBehaviour = sharkGameObject.GetComponent<SharkBehaviour>();
    }

    private void Update()
    {
        
    }

   





}
