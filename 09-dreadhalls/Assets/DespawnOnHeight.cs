using System;
using UnityEngine;
using UnityEngine.SceneManagement;

public class DespawnOnHeight : MonoBehaviour
{
	private CharacterController _characterController;
	private float _heightThreshold;

	void Awake()
	{
		_characterController = GetComponent<CharacterController>();
		_heightThreshold = GameObject.Find("FloorParent").transform.position.y;
	}

	void Update() {
		if (_characterController.transform.position.y < _heightThreshold)
		{
			SceneManager.LoadScene("GameOver");
		}
	}
}