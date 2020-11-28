extends KinematicBody2D

var state_machine: AnimationNodeStateMachinePlayback
var run_speed = 500
var velocity = Vector2.ZERO
var gravity: float = 10000

func _ready() -> void:
	state_machine = $AnimationTree.get("parameters/playback")

func get_input():
	velocity = Vector2.ZERO
	var current = state_machine.get_current_node()
	if Input.is_action_just_pressed("game_quit"):
		get_tree().quit()
	
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
		flip_h(false)

	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
		flip_h(true)
	
	if Input.is_action_pressed("player_jump"):
		velocity.y -= 1000
		jump()
	
	velocity.x = velocity.x * run_speed
	
	if (velocity.y != 0):
		jump()
	elif (velocity.x == 0 && is_on_floor()):
		state_machine.travel("idle")
	elif (velocity.x != 0 && is_on_floor()):
		state_machine.travel("run")


func _physics_process(delta: float) -> void:
	get_input()
	velocity.y += gravity * delta
	move_and_slide(velocity, Vector2.UP)

func jump():
	state_machine.travel("jump")

func flip_h(flip:bool):
	var x_axis = global_transform.x
	global_transform.x.x = (-1 if flip else 1) * abs(x_axis.x)
