﻿using UnityEngine;
using UnityEditor;
using System.Collections;

public class GenerateStaticCubemap : ScriptableWizard 
{
	public Transform renderPosition;
	public Cubemap cubemap;
	

	void OnWizardUpdate()
	{
		if (renderPosition != null && cubemap != null) {
						isValid = true;
				} else {
			isValid = false;
				}
	}

	void OnWizardCreate()
	{
		GameObject go = new GameObject ("CubeCam", typeof(Camera));

		go.transform.position = renderPosition.position;
		go.transform.rotation = Quaternion.identity;

		go.camera.RenderToCubemap (cubemap);

		DestroyImmediate (go);
	}

	[MenuItem("CookBook/Render Cubemap")]
	static void RenderCubemap()
	{
		ScriptableWizard.DisplayWizard("Render Cubemap",typeof(GenerateStaticCubemap),"Render!");
		}
}
