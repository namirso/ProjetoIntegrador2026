extends Control

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	animated_sprite_2d.play('idle')


func _process(delta: float) -> void:
	pass


func _on_iniciar_pressed() -> void:
	get_tree().change_scene_to_file("res://cenas/intro.tscn")


func _on_sair_pressed() -> void:
	get_tree().quit() 
