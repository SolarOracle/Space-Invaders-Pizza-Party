extends Node

@onready var shot_timer = $ShotTimer

var invader_count: int = 0
var shooters: Array = []
signal check_if_shooter
signal update_speed

func _ready():
	for i in 5:
		await Engine.get_main_loop().process_frame
	check_if_shooter.emit()

func invader_death():
	await Engine.get_main_loop().process_frame
	invader_count -= 1
	check_if_shooter.emit()
	if invader_count <= 40 and shot_timer.wait_time > 1.0:
		update_speed.emit(200)
		shot_timer.wait_time = 1.0
	elif invader_count <= 20 and shot_timer.wait_time > 0.5:
		update_speed.emit(300)
		shot_timer.wait_time = 0.5
	elif invader_count <= 5 and shot_timer.wait_time > 0.4:
		update_speed.emit(400)
		shot_timer.wait_time = 0.4
	elif invader_count <= 1 and shot_timer.wait_time > 0.3:
		update_speed.emit(500)
		shot_timer.wait_time = 0.3

func select_shooter():
	var shooter = shooters.pick_random()
	shooter.shoot()

func _on_shot_timer_timeout():
	if shooters.size() > 0:
		select_shooter()
	else:
		shot_timer.paused = true
