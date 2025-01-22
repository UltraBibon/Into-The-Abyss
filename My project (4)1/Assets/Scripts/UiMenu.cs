using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class UiMenu : MonoBehaviour
{
    [SerializeField] public Button start;
    [SerializeField] public Button exit;
    [SerializeField] private GameObject player;
    [SerializeField] private PlayerControllerManager playerManage;


    private void Awake()
    {
        start.onClick.AddListener(Start_Game);
        exit.onClick.AddListener(Exit);
        playerManage = player.GetComponent<PlayerControllerManager>();
    }


    private void Start_Game()
    {
        gameObject.SetActive(false);
        playerManage.isopened = false;
        Time.timeScale = 1;
    }

    private void Exit()
    {
#if UNITY_EDITOR
        UnityEditor.EditorApplication.isPlaying = false;
#else
    UnityEngine.Application.Quit();
#endif
    }


}
