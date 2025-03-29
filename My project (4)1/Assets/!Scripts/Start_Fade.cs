using System.Collections;
using Unity.VisualScripting;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.SceneManagement;
using UnityEngine.UI;

public class Start_Fade : MonoBehaviour
{

    [SerializeField] GameObject start;
    [SerializeField] GameObject end;
    [SerializeField] public Button start_button;
    [SerializeField] public Button exit;
    private float fade_speed = 0.3f;
    [SerializeField] AudioSource audioSource;
    


    private void Start()
    {
        Time.timeScale = 0;
        EventSystem.current.SetSelectedGameObject(start);
        start_button.onClick.AddListener(Start_Game);
        exit.onClick.AddListener(Exit);
    }

    private void Start_Game()
    {
        audioSource.Play();
        Time.timeScale = 1;
        start.SetActive(false);
        end.SetActive(false);
        gameObject.SetActive(false);
    }


    private void Exit()
    {
#if UNITY_EDITOR
        UnityEditor.EditorApplication.isPlaying = false;
#else
    UnityEngine.Application.Quit();
#endif
    }

    /*
    IEnumerator Fade1()
    {
        Image fade_img = GetComponent<Image>();
        Color color = fade_img.color;
        while (color.a > 0f)
        {
            color.a -= fade_speed * Time.deltaTime;
            fade_img.color = color;
            yield return new WaitForSeconds(0.01f);
        }
    }
    */
}
