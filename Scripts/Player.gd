extends KinematicBody2D

var run = Vector2.ZERO
var velocity = Vector2.ZERO
var move_speed = 480
var gravity = 1200
var jump_force = -720
var is_grounded
var player_health = 3
var max_health = 3
var hurted = false
var knockback_dir = 1
var knockback_int = 500
onready var raycasts = $raycasts

export var player_index = "1"

signal change_life(player_health)

func _ready() -> void:
	connect("change_life", get_parent().get_node("HUD/HBoxContainer/Holder2"), "on_change_life")
	emit_signal("change_life", max_health)
	
func _on_sobe(player):
	print("Sobe " + player)
	if player == player_index:
		 position.y += 20

func _on_desce(player):
	print("Desce " + player)
	if player == player_index:
		position.y -= 20

func _on_potenciometro(player, value):
	print("Potenciometro " + player + " -> " + value)
	if player == player_index:
		position.x += int(value)

func _on_joystick(player, x_value, y_value):
	print("Joystick " + player + " -> "+ x_value + ", " + y_value)
	if player == player_index:
		position.x += int(x_value)
		position.y -= int(y_value)

func _physics_process(delta: float) -> void:
	velocity.y += gravity * delta
	
	_get_input()
	
	velocity = move_and_slide(velocity)
	
	is_grounded = _check_is_ground()
	
	_set_animation()
	
func _get_input():
	velocity.x = 0
	var move_direction = int(Input.is_action_pressed("move_rigth")) - int(Input.is_action_pressed("move_left"))
	velocity.x = lerp(velocity.x, move_speed * move_direction, 0.2)
	
	if move_direction != 0:
		$texture.scale.x = move_direction
		knockback_dir = move_direction
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("jump") && is_grounded:
		velocity.y = jump_force / 2
	
func _check_is_ground():
	for raycast in raycasts.get_children():
		if raycast.is_colliding():
			return true
	
	return false		
	
func _set_animation():
	var anim = "idle"
	
	if !is_grounded:
		anim = "jump"
	elif velocity.x != 0:
		anim = "run"
	
	if hurted:
		anim = "hit"
	
	if $anim.assigned_animation	!= anim:
		$anim.play(anim)

func knockback():
	velocity.x = -knockback_dir * knockback_int
	velocity = move_and_slide(velocity)

func _on_hurtbox_body_entered(body: Node) -> void:
	player_health -= 1
	hurted = true
	emit_signal("change_life", player_health)
	knockback()
	get_node("hurtbox/collision").set_deferred("disabled", true)
	yield(get_tree().create_timer(0.5), "timeout")
	get_node("hurtbox/collision").set_deferred("disabled", false)
	hurted = false
	_gameOver()

func _gameOver() -> void:
	if player_health < 1:
		queue_free()
		get_tree().change_scene("res://Prefabs/GameOver.tscn")
	

func _on_Level_01_direita():
	run.x = 1
	run = move_and_slide(run)
	print("Cheguei direita")
	
	
func _on_Level_01_cima():
	run.y = -1
	run = move_and_slide(run)
	print("Cheguei cima")

func _on_Level_01_esquerda():
	run.x = -1
	run = move_and_slide(run)
	print("Cheguei esquerda")
