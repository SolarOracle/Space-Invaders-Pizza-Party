extends Node

@onready var shot_timer = $ShotTimer
@onready var game_manager = $"../GameManager"

var invader_count: int
var shooters: Array = []
signal check_if_shooter
signal update_speed
signal clear_shots

func _ready():
	for i in 10:
		await Engine.get_main_loop().process_frame
	check_if_shooter.emit()

func invader_death():
	await Engine.get_main_loop().process_frame
	invader_count -= 1
	check_if_shooter.emit()
	if invader_count <= 40 and shot_timer.wait_time > 1.3:
		update_speed.emit(200)
		shot_timer.wait_time = 1.3
	elif invader_count <= 30 and shot_timer.wait_time > 1.0:
		update_speed.emit(250)
		shot_timer.wait_time = 1.0
	elif invader_count <= 20 and shot_timer.wait_time > 0.8:
		update_speed.emit(300)
		shot_timer.wait_time = 0.8
	elif invader_count <= 10 and shot_timer.wait_time > 0.7:
		update_speed.emit(350)
		shot_timer.wait_time = 0.7
	elif invader_count <= 5 and shot_timer.wait_time > 0.65:
		update_speed.emit(400)
		shot_timer.wait_time = 0.65
	elif invader_count <= 1 and shot_timer.wait_time > 0.6:
		update_speed.emit(500)
		shot_timer.wait_time = 0.6
	elif invader_count <= 0:
		shot_timer.paused = true
		clear_shots.emit()
		if level_definitions.game_level == 2:
			game_manager.win_game()
		else:
			game_manager.win_level()

func select_shooter():
	var shooter = shooters.pick_random()
	shooter.shoot()

func _on_shot_timer_timeout():
	if shooters.size() > 0:
		select_shooter()
