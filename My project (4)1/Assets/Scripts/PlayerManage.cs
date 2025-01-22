using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;

public class PlayerManage : MonoBehaviour
{

    [SerializeField] Button reset_game_from_end;
    [SerializeField] Button reset_game_from_win;
    //[SerializeField] Button exitgame_end;
    //[SerializeField] Button exitgame_win;
    [SerializeField] GameObject selected_button_end;
    [SerializeField] GameObject selected_button_win;
    [SerializeField] GameObject lose_canvas;
    [SerializeField] GameObject win_canvas;
    [SerializeField] Light pointerlight;
    [SerializeField] GameObject[] boxes;
    [SerializeField] GameObject[] boxes_to_spawn;
    [SerializeField] GameObject shark;

    public float _HP = 100;
    public int box_counter = 0;
    public float oxygen;

    public Image mask;
    public Image mask2;

    private Quaternion OriginalPos;
    private Rigidbody rb;

    private void Awake()
    {
        reset_game_from_end.onClick.AddListener(PLayAgain);
        reset_game_from_win.onClick.AddListener(PLayAgain);
        //exitgame_end.onClick.AddListener(Exit);
        //exitgame_win.onClick.AddListener(Exit);
        rb = GetComponent<Rigidbody>();
        OriginalPos = transform.rotation;
    }

    private void Update()
    {
        oxygen -= Time.deltaTime;
        GetFill();
        if (oxygen <=0)
        {
            lose_canvas.SetActive(true);
            pointerlight.color = Color.white;
            shark.SetActive(false);
            Debug.Log("oxegen");
            Time.timeScale = 0;
            EventSystem.current.SetSelectedGameObject(selected_button_end);
        }

        GetHp();

        if (_HP<=0)
        {
            
            lose_canvas.SetActive(true);
            pointerlight.color = Color.white;
            shark.SetActive(false);
            Debug.Log("HP");
            Time.timeScale = 0;
            EventSystem.current.SetSelectedGameObject(selected_button_end);
        }

        if (box_counter == 1)
        {
            boxes[0].SetActive(true);
        }
        if (box_counter == 2)
        {
            boxes[1].SetActive(true);
        }
        if (box_counter == 3)
        {
            boxes[2].SetActive(true);
        }
        if (box_counter == 4)
        {
            boxes[3].SetActive(true);
        }
        if (box_counter == 5)
        {
            boxes[4].SetActive(true);
        }
        if (box_counter == 6)
        {
            boxes[5].SetActive(true);
        }
        if (box_counter == 7)
        {
            boxes[6].SetActive(true);
        }
        if (box_counter == 8)
        {
            boxes[7].SetActive(true);
        }
        if (box_counter == 9)
        {
            boxes[8].SetActive(true);
        }
        if (box_counter == 10)
        {
            boxes[9].SetActive(true);
        }
        if (box_counter ==11)
        {
            boxes[10].SetActive(true);
        }
        if (box_counter == 12)
        {
            win_canvas.SetActive(true);
            boxes[11].SetActive(true);
            Time.timeScale = 0;
            EventSystem.current.SetSelectedGameObject(selected_button_win);
        }



    }
    
    private void Exit()
    {
#if UNITY_EDITOR
        UnityEditor.EditorApplication.isPlaying = false;
#else
    UnityEngine.Application.Quit();
#endif
    }

    private void PLayAgain()
    {
        Time.timeScale = 1;
        _HP = 100;
        oxygen = 360f;
        lose_canvas.SetActive(false);
        boxes[0].SetActive(false);
        boxes[1].SetActive(false);
        boxes[2].SetActive(false);
        boxes[3].SetActive(false);
        boxes[4].SetActive(false);
        boxes[5].SetActive(false);    
        boxes[6].SetActive(false);
        boxes[7].SetActive(false);
        boxes[8].SetActive(false);
        boxes[9].SetActive(false);
        boxes[10].SetActive(false);
        boxes[11].SetActive(false);


        boxes_to_spawn[0].SetActive(true);
        boxes_to_spawn[1].SetActive(true);
        boxes_to_spawn[2].SetActive(true);
        boxes_to_spawn[3].SetActive(true);
        boxes_to_spawn[4].SetActive(true);
        boxes_to_spawn[5].SetActive(true);
        boxes_to_spawn[6].SetActive(true);
        boxes_to_spawn[7].SetActive(true);
        boxes_to_spawn[8].SetActive(true);
        boxes_to_spawn[9].SetActive(true);
        boxes_to_spawn[10].SetActive(true);
        boxes_to_spawn[11].SetActive(true);
        boxes_to_spawn[12].SetActive(true);
        boxes_to_spawn[13].SetActive(true);
        boxes_to_spawn[14].SetActive(true);
        boxes_to_spawn[15].SetActive(true);

        transform.position = new Vector3(-61f, 33f, 289f);
        transform.rotation= OriginalPos;
        rb.isKinematic = false;
        rb.isKinematic = true;
        rb.isKinematic = false;
        box_counter = 0;



    }

    private void GetFill()
    {
        float amount = oxygen / 360;
        mask.fillAmount = amount;
    }

    private void GetHp()
    {
        float amount1 = _HP / 100;
        mask2.fillAmount = amount1;
    }

}
