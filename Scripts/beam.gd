extends CharacterBody2D

@export var speed: float = 300

@onready var player = $"../PlayerTest"

func _process(delta):
	move_and_slide()
	position -= transform.y * speed * delta
	
	var collision = get_last_slide_collision()
	
	if (collision):
		var collider = collision.get_collider()
		hit()

func hit():
	player.can_shoot = true
	queue_free()
