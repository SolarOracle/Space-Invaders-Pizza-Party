extends CharacterBody2D

@export var move_speed : float = 400
@export var max_health : int = 1

@onready var rc_left = $RaycastLeft
@onready var rc_right = $RaycastRight
@onready var rc_down = $RaycastDown
@onready var rc_up = $RaycastUp
@onready var border_detect_left = $BorderDetectLeft
@onready var border_detect_right = $BorderDetectRight

var direction : int = -1
var previous_direction : int 
var current_health : int = max_health
var moving_down : bool = false
var current_height : Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _physics_process(delta):
	if border_detect_left.is_colliding() or border_detect_right.is_colliding():
		border_detect_left.enabled = false
		border_detect_right.enabled = false
		previous_direction = direction
		moving_down = true
		current_height = position
	
	move_and_slide()
	if moving_down == false:
		position += transform.x * direction * delta * move_speed
	else:
		position += transform.y * delta * move_speed
		if position.distance_to(current_height) >= 40:
			direction = previous_direction * -1
			moving_down = false
			border_detect_left.enabled = true
			border_detect_right.enabled = true
	
func hit():
	current_health = current_health - 1
	if current_health < 0:
		current_health = 0
	if current_health == 0:
		destroy()

func destroy():
	queue_free()
