extends Node

var shooters: Array = []
signal check_if_shooter

func invader_death():
	check_if_shooter.emit()

func select_shooter():
	var shooter = shooters.pick_random()
	shooter.shoot()

func _on_timer_timeout():
	select_shooter()
