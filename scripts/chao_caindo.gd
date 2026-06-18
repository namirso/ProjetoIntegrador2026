extends RigidBody2D

@onready var gatilho: Area2D = $Gatilho
var ja_pisou := false

func _ready() -> void:
	gatilho.body_entered.connect(_on_gatilho_body_entered)

func _on_gatilho_body_entered(body: Node2D) -> void:
	if body.name == "Coelho" and not ja_pisou:
		ja_pisou = true
		
		await get_tree().create_timer(0.4).timeout
		
		if ja_pisou:
			set_deferred("freeze", false)
