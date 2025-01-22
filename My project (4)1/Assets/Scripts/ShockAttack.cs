using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ShockAttack : MonoBehaviour
{
    [SerializeField] ParticleSystem ParticleSystem1;
    [SerializeField] ParticleSystem ParticleSystem2;
    [SerializeField] ParticleSystem ParticleSystem3;
    [SerializeField] ParticleSystem ParticleSystem4;
    [SerializeField] Light _light;
    [SerializeField] SharkBehaviour _sharkBehaviour;
    [SerializeField] GameObject shark;
    [SerializeField] GameObject player;
    [SerializeField] AudioSource audioSource;

    PlayerControllerManager _player;
    private float Timer2 = 0f;
    private float Timer = 0f;
    public bool isshock = false;
    private Color electro = new Color(0f, 0.407f, 0.737f);
    private Color curcor;



    private void Start()
    {
        _sharkBehaviour = shark.GetComponent<SharkBehaviour>();
        _player = player.GetComponent<PlayerControllerManager>();
    }

    private void Update()
    {
        
        if (isshock)
        {
            if (Timer < 0.35f)
            {
                Timer += Time.deltaTime;
                float progress = Mathf.Clamp01(Timer / 0.7f);
                GetComponent<Light>().color = Color.Lerp(Color.white, electro, progress);
            }
            else
            {
                if (Timer2 < 0.35f)
                {
                    Timer2 += Time.deltaTime;
                    float progressback = Mathf.Clamp01(Timer2/0.7f);
                    GetComponent<Light>().color = Color.Lerp(electro, Color.white, progressback);
                }
                else
                {
                    Timer = 0f;
                    Timer2 = 0f;
                    isshock = false;
                    GetComponent<Light>().color = Color.white;
                }
            }
        }
        
        
    }

    public void Shock(bool can)
    {
        if (can)
        {
            _sharkBehaviour.shark_hp--;
            isshock = true;
            ParticleSystem1.Play();
            ParticleSystem2.Play();
            ParticleSystem3.Play();
            ParticleSystem4.Play();
            audioSource.Play();
            can = false;
            _player.can = false;
        }
    }

}
