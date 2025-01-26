extends Node2D

const MAIN_SCENE = preload("res://main.tscn")


func _process(_delta):
	if Input.is_action_just_pressed("cut"):
		get_tree().change_scene_to_packed(MAIN_SCENE)
