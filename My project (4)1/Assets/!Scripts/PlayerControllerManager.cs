using System.Collections;
using System.Collections.Generic;
using System.Security.Cryptography;
using System.Xml.Linq;
using UnityEngine;
using UnityEngine.InputSystem;
using UnityEngine.EventSystems;
using System.Runtime.InteropServices.ComTypes;
using UnityEngine.UI;

public class PlayerControllerManager : MonoBehaviour
{

    //floats - movement
    [SerializeField] public float up_speed;
    [SerializeField] public float m_speed;
    [SerializeField] public float r_speed;

    //movement
    Controller inputActions;
    Vector2 move;
    Vector2 rotate;

    //objects
    [SerializeField] public Rigidbody rb;
    [SerializeField] public GameObject lights;
    [SerializeField] public GameObject Menu;
    [SerializeField] public GameObject shockerManager;
    [SerializeField] public GameObject start;


    [SerializeField] public float reload_cnt;
    [SerializeField] public Image mask;

    //audio
    [SerializeField] public AudioSource alightson;
    [SerializeField] public AudioSource alightsof;
    [SerializeField] public AudioSource music;

    //helpers
    public bool can = false;
    private float c;

    private bool islightson = false;
    public  bool isopened = false;

    private ShockAttack shockAttack;

  

    private void Awake()
    {
        rb = GetComponent<Rigidbody>();
        inputActions = new Controller();
        shockAttack = shockerManager.GetComponent<ShockAttack>();

        inputActions.PlayerController.Move.performed += ctx => move = ctx.ReadValue<Vector2>();
        inputActions.PlayerController.Move.canceled += ctx => move = Vector2.zero;

        inputActions.PlayerController.Rotate.performed += ctx => rotate = ctx.ReadValue<Vector2>();
        inputActions.PlayerController.Rotate.canceled += ctx => rotate = Vector2.zero;

        inputActions.PlayerController.Lights.performed += ctx => LightsOn();

        inputActions.PlayerController.Shock.performed += ctx => shockAttack.Shock(can);


        //потом переписать
        /*
        inputActions.PlayerController.Up.performed += ctx => Submarine_Up();
        inputActions.PlayerController.Up.canceled += ctx => Submarine_Down();

        inputActions.PlayerController.Down.performed += ctx => isdown=true;
        inputActions.PlayerController.Down.canceled += ctx => isdown = false;
        */

        inputActions.PlayerController.Options.performed += ctx => Open_Menu();

        Quaternion OriginalPos = transform.rotation;
        inputActions.PlayerController.ResetPosition.performed += ctx => Reset_Rotation(OriginalPos);

        inputActions.PlayerController.Reload.performed += ctx => Reload();
        
    }

    private void FixedUpdate()
    {
        DirectMove();
        ObjectRotator();
        

        if(can==false)
        {
            GetFill();
        }


        if (inputActions.PlayerController.Up.IsPressed()) 
        {
            rb.AddRelativeForce(new Vector3(0, 1, 0) * up_speed, ForceMode.Force);
        }
        

        if (inputActions.PlayerController.Down.IsPressed())
        {
            rb.AddRelativeForce(new Vector3(0, -1, 0) * up_speed, ForceMode.Force);
        }

        if (inputActions.PlayerController.Boost.IsPressed()) 
        {
            m_speed = 17;
        }
        else
        {
            m_speed = 7f;
        }


    }


    private void Open_Menu()
    {
        if (isopened)
        {
            Menu.SetActive(false);
            isopened = false;
            music.UnPause();
            Time.timeScale = 1;
            EventSystem.current.SetSelectedGameObject(start);
        }
        else
        {
            Menu.SetActive(true);
            isopened = true;
            music.Pause();
            Time.timeScale = 0;
            EventSystem.current.SetSelectedGameObject(start);
        }
    }


    #region SubmarineFunctions

    private void GetFill()
    {
        float progress = c/reload_cnt;
        mask.fillAmount = progress;
    }

    private void LightsOn()
    {
        if (islightson)
        {
            lights.SetActive(false);
            islightson = false;
            alightsof.Play();
        }
        else
        {
            lights.SetActive(true);
            islightson = true;
            alightson.Play();
        }
    }

    private void Reset_Rotation(Quaternion rot)
    {
        transform.rotation = rot;
        rb.isKinematic = false;
        rb.isKinematic = true;
        rb.isKinematic = false;
    }

    private void Reload()
    {
        c++;
        if (c == reload_cnt) 
        {
            can = true;
            c = 0;
        }
    }

    #endregion

    #region Moving methods
    private void DirectMove()
    {
        rb.AddRelativeForce(VectorDirection() * m_speed, ForceMode.Force);
    }

    private Vector3 VectorDirection()
    {
        Vector3 m = Vector3.zero;
        m.x = -move.x;
        m.z = -move.y;

        if (m.magnitude > 1)
        {
            m.Normalize();
        }

        return m;
    }

    private void ObjectRotator()
    {
        Vector3 r = new Vector3(rotate.y, rotate.x, 0) * r_speed;
        transform.Rotate(r);
    }

    #endregion

    #region Enable/Disable
    private void OnEnable()
    {
        inputActions.PlayerController.Enable();
    }
    private void OnDisable()
    {
        inputActions.PlayerController.Disable();
    }
    #endregion


}
