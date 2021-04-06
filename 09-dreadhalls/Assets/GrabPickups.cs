using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class GrabPickups : MonoBehaviour {

	public static int PickupCounter;
	
	private AudioSource _pickupSoundSource;

	void Awake() {
		_pickupSoundSource = DontDestroy.instance.GetComponents<AudioSource>()[1];
	}

	void OnControllerColliderHit(ControllerColliderHit hit) {
		if (hit.gameObject.CompareTag("Pickup")) {
			_pickupSoundSource.Play();
			PickupCounter++;
			SceneManager.LoadScene("Play");
		}
	}
}
