using UnityEngine;

public class ContainerBehaviour : MonoBehaviour
{

    [SerializeField] GameObject container;
    [SerializeField] GameObject player;
    [SerializeField] private PlayerManage playerManage;
    [SerializeField] public bool shark = false;
    [SerializeField] public GameObject _shark;
    [SerializeField] public bool oxygen_add;
    [SerializeField] public bool armor_add;
    [SerializeField] public float howmany_armor;
    [SerializeField] public float howmany_oxygen;
    [SerializeField] AudioSource adding_sound;

    private SharkBehaviour _sharkBehaviour;

    private void Start()
    {
        playerManage = player.GetComponent<PlayerManage>();
        _sharkBehaviour = _shark.GetComponent<SharkBehaviour>();
    }


    private void OnTriggerEnter(Collider other)
    {



        if (other.CompareTag("Player"))
        {
            playerManage.box_counter += 1;
            adding_sound.Play();
            container.SetActive(false);
            if (shark)
            {
                _sharkBehaviour.shark_hp = 1;
                _shark.SetActive(true);
            }

            if (armor_add)
            {
                playerManage._HP += howmany_armor;
            }
            else if(oxygen_add)
            {
                playerManage.oxygen += howmany_oxygen;
            }
            

        }

    }
}
