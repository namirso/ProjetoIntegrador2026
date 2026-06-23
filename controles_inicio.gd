extends CanvasLayer

@onready var painel: PanelContainer = $PanelContainer

func _ready() -> void:
	painel.modulate.a = 0.0
	
	animar_informativo()


func animar_informativo() -> void:
	var tween = create_tween()
	
	tween.tween_property(painel, "modulate:a", 1.0, 0.5)
	
	tween.tween_interval(4.0)
	
	tween.tween_property(painel, "modulate:a", 0.0, 0.5)
	
	tween.tween_callback(queue_free)
