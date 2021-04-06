using System.Net.Mime;
using UnityEngine;
using UnityEngine.UI;

public class LevelCounter : MonoBehaviour
{
    private Text _levelText;  
 
    void Start () {
        _levelText = GetComponent<Text>();  
    }
 
    void Update () {
        _levelText.text = GrabPickups.PickupCounter.ToString();  
    }
}
