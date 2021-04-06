using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class OnFinish : MonoBehaviour
{
    private Text _levelCompleteText;
    
    void Start()
    {
        _levelCompleteText = GameObject.Find("LevelComplete").GetComponent<Text>();
        
		_levelCompleteText.color = new Color(0, 0, 0, 0);
    }
    private void OnTriggerEnter(Collider other)
    {
        if (!other.CompareTag("Player")) return;
        
        _levelCompleteText.color = new Color(0, 0, 0, 1);
        _levelCompleteText.text = "Level Complete!";
    }
}
