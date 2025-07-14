extends Node

@export var mob_scene: PackedScene
var score
var highest_score = 0

func game_over() -> void:
	$ScoreTimer.stop()
	$MobTimer.stop()
	$VirtualControl.hide()
	$HUB.show_game_over()
	$Music.stop()
	$DeathSound.play()
	
	if score > highest_score:
		highest_score = score
		
		var config = ConfigFile.new()
		config.set_value('player', 'highest_score', highest_score)
		config.save('user://data.cfg')
		
		print_debug('数据已保存!')
	
	$HUB/HighestScore.text = '最高分: ' + str(highest_score)
	$HUB/HighestScore.show()

func new_game() -> void:
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	get_tree().call_group("mobs", "queue_free")
	$VirtualControl.show()
	$HUB/HighestScore.hide()
	$HUB.update_score(score)
	$HUB.show_message('做好准备')
	$Music.play()

func _ready() -> void:
	var config = ConfigFile.new()
	var result = config.load('user://data.cfg')
	
	if result == OK:
		highest_score = config.get_value('player', 'highest_score', highest_score)
		
		print_debug('数据已加载!')
	else:
		printerr('加载数据时发生错误❌!')

func _on_score_timer_timeout() -> void:
	score += 1
	$HUB.update_score(score)

func _on_start_timer_timeout() -> void:
	$MobTimer.start()
	$ScoreTimer.start()

func _on_mob_timer_timeout() -> void:
	var mob = mob_scene.instantiate()
	
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()
	
	mob.position = mob_spawn_location.position
	
	var direction = mob_spawn_location.rotation + PI / 2
	
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction
	
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)
	
	add_child(mob)
