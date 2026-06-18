extends CharacterBody2D

const SPEED = 200.0
const RUN_SPEED = 350.0
const JUMP_VELOCITY = -550.0
const GRAVITY = 900.0
const FRICTION = 600.0
const AIR_FRICTION = 150.0 

const WALL_SLIDE_SPEED = 100.0
const WALL_JUMP_FORCE = Vector2(400, -450) 
const MAX_WALL_TIME = 1.5 

const MIN_CHARGE_JUMP = -300.0 
const MAX_CHARGE_JUMP = -700.0 
const MAX_CHARGE_TIME = 1.0 

var is_jumping := false
var on_wall := false
var ativo := true # Mantido para o portal identificar o jogador
var wall_jump_timer := 0.0
var wall_time_spent := 0.0 
var posicao_checkpoint: Vector2

var is_charging := false
var charge_time := 0.0

@export var camera_zoom := Vector2(1.5,1.5)

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var ray_left: RayCast2D = $RayCastLeft
@onready var ray_right: RayCast2D = $RayCastRight
@onready var charge_bar: ProgressBar = $ProgressBar

func _ready():
	if Global.usar_checkpoint:
		global_position = Global.posicao_checkpoint
	sprite.play("idle")
	
	charge_bar.visible = false
	charge_bar.max_value = MAX_CHARGE_TIME
	charge_bar.value = 0.0

func _physics_process(delta: float) -> void:

	if not is_on_floor():
		velocity.y += GRAVITY * delta
		is_charging = false 
		charge_time = 0.0
		charge_bar.visible = false 
	else:
		is_jumping = false
		on_wall = false
		wall_time_spent = 0.0 

	if wall_jump_timer > 0:
		wall_jump_timer -= delta

	var direction := Input.get_axis("ui_left", "ui_right")

	var touching_left = ray_left.is_colliding()
	var touching_right = ray_right.is_colliding()

	on_wall = (
		(touching_left and direction < 0 or touching_right and direction > 0)
		and not is_on_floor()
		and velocity.y > 0
		and wall_time_spent < MAX_WALL_TIME
	)

	if direction != 0:
		sprite.flip_h = direction < 0

	if is_charging:
		direction = 0.0

	if wall_jump_timer <= 0:
		if not on_wall:
			if direction != 0:
				var current_speed := SPEED
				
				sprite.speed_scale = 1.0 
				
				if is_on_floor() and Input.is_action_pressed("acao_correr"):
					current_speed = RUN_SPEED
					
					sprite.speed_scale = 1.5 

				velocity.x = direction * current_speed
			else:
				var f = FRICTION if is_on_floor() else AIR_FRICTION
				velocity.x = move_toward(velocity.x, 0, f * delta)
				
				sprite.speed_scale = 1.0

	if on_wall:
		wall_time_spent += delta
		
		velocity.y = min(velocity.y, WALL_SLIDE_SPEED)

		if Input.is_action_just_pressed("ui_accept"):
			var jump_dir = 1 if touching_left else -1
			
			velocity = Vector2(WALL_JUMP_FORCE.x * jump_dir, WALL_JUMP_FORCE.y)
			on_wall = false
			is_jumping = true
			
			wall_jump_timer = 0.15
			wall_time_spent = 0.0 

	if is_on_floor():
		if Input.is_action_pressed("pulo_carregado"):
			is_charging = true
			charge_time = min(charge_time + delta, MAX_CHARGE_TIME)
			
			charge_bar.visible = true
			charge_bar.value = charge_time
			
		elif Input.is_action_just_released("pulo_carregado") and is_charging:
			var charge_ratio = charge_time / MAX_CHARGE_TIME
			velocity.y = lerp(MIN_CHARGE_JUMP, MAX_CHARGE_JUMP, charge_ratio)
			
			is_jumping = true
			is_charging = false
			charge_time = 0.0
			charge_bar.visible = false 
		else:
			if not Input.is_action_pressed("pulo_carregado"):
				is_charging = false
				charge_time = 0.0
				charge_bar.visible = false 

	if Input.is_action_just_pressed("ui_accept") and is_on_floor() and not is_charging:
		velocity.y = JUMP_VELOCITY
		is_jumping = true
	
		

	move_and_slide()

func morrer():
	get_tree().call_deferred("reload_current_scene")
