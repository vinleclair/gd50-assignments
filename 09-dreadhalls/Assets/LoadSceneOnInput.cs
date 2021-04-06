using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class LoadSceneOnInput : MonoBehaviour {
	
	private static string _activeSceneName;

	// Use this for initialization
	void Start () {
	}
	
	// Update is called once per frame
	void Update () {
		if (Input.GetAxis("Submit") == 1)
		{
			_activeSceneName = SceneManager.GetActiveScene().name;
			switch (_activeSceneName)
			{
				case "Title": 
					SceneManager.LoadScene("Play");
					break;
				case "GameOver": 
					GrabPickups.PickupCounter = 0;
					Destroy(GameObject.Find("WhisperSource")); 
					SceneManager.LoadScene("Title");
					break;
			}
		}
	}
}
