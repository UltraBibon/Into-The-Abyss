using JetBrains.Annotations;
using System.Collections;
using System.Collections.Generic;
using Unity.VisualScripting;
using UnityEngine;

public class SharkBehaviour : MonoBehaviour
{

    [SerializeField] public int shark_hp = 1;
    [SerializeField] GameObject player;
    [SerializeField] public float damage;
    [SerializeField] public float timer;
    [SerializeField] Light pointLight;

    private float time = 0f;
    PlayerManage playerManage;

    private void Awake()
    {
        playerManage = player.GetComponent<PlayerManage>();
    }

    private void Update()
    {
        time += Time.deltaTime;
        if (time > timer)
        {
            playerManage._HP -= damage;
            time = 0f;
        }

        if (shark_hp > 0)
        {
            pointLight.color = Color.red;

        }


        if (shark_hp < 0)
        {
            pointLight.color = Color.white;
            gameObject.SetActive(false);
        }
    }


}
