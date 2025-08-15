extends Node

var invader_count: int = 0
var shooters: Array = []
signal check_if_shooter

func invader_death():
	invader_count -= 1
	check_if_shooter.emit()

func select_shooter():
	var shooter = shooters.pick_random()
	shooter.shoot()

func _on_shot_timer_timeout():
	if shooters.size() > 0:
		select_shooter()
