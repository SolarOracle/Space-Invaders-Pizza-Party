extends CharacterBody2D

@export var speed: float = 300
@export var direction: int
@onready var player = get_node("/root/TestScene/PlayerTest")

func _process(delta):
	move_and_slide()
	position -= transform.y * speed * delta * direction
	
	var collision = get_last_slide_collision()
	
	if (collision):
		var collider = collision.get_collider()
		if collider.collision_layer != 8:
			collider.hit()
		hit()

func hit():
	if direction == 1 and player != null:
		player.can_shoot = true
	queue_free()
