extends StaticBody2D

@export var max_health : int = 10

var current_health: int = max_health

func hit():
	current_health = current_health - 1
	if current_health < 0:
		current_health = 0
	if current_health == 0:
		destroy()
	change_color()
	
func destroy():
	queue_free()

func change_color():
	if current_health < 9 and current_health > 6 and modulate != Color(0.678431, 1, 0.184314, 1):
		modulate = Color(0.678431, 1, 0.184314, 1)
	elif current_health < 7 and current_health > 4 and modulate != Color(1, 1, 0, 1):
		modulate = Color(1, 1, 0, 1)
	elif current_health < 5 and current_health > 2 and modulate != Color(1, 0.270588, 0, 1):
		modulate = Color(1, 0.270588, 0, 1)
	elif current_health < 3 and current_health > 0 and modulate != Color(1,0,0,1):
		modulate = Color(1, 0, 0, 1)
