using Futurift;
using Futurift.DataSenders;
using Futurift.Options;
using UnityEngine;
using System;

public class CapsulaController : MonoBehaviour
{
    private FutuRiftController _controller;

    [SerializeField] 
    public string ip;
    [SerializeField] 
    public int port;

    private void Awake()
    {
        _controller = new FutuRiftController(
            new UdpPortSender(new UdpOptions()
            {
                ip = this.ip,
                port = this.port
            })
            );
        _controller.Start();
    }

    void OnEnable()
    {
        _controller.Start();
    }

    void OnDisable()
    {
        _controller.Stop();
    }

    private void Update()
    {
        var rot = transform.eulerAngles;
        rot.x = rot.x > 180 ? rot.x - 360 : rot.x;
        rot.y = rot.y > 180 ? rot.y - 360 : rot.y;

        //подъем и спуск
        _controller.Pitch = rot.x;
        //повоорт влево/вправо
        _controller.Roll = rot.y;
    }
}
