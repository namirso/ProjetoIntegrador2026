extends Node

@onready var cam: Camera2D = $Camera2D
@onready var coelho: CharacterBody2D = $personagens/Coelho

func _ready():
	_mover_camera_para(coelho)


func _mover_camera_para(player):
	if cam.get_parent() != null:
		cam.get_parent().remove_child(cam)

	player.add_child(cam)

	cam.position = Vector2.ZERO

	var zoom = player.get("camera_zoom")
	if zoom != null:
		cam.zoom = zoom
	else:
		cam.zoom = Vector2(1, 1) 

	cam.make_current() 
