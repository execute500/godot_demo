extends RigidBody2D

func _ready() -> void:
	var mob_types = Array($AnimatedSprite2D.sprite_frames.get_animation_names())
	var mob_type = mob_types.pick_random()
	var mob_frame = $AnimatedSprite2D.frame
	
	$AnimatedSprite2D.animation = mob_type
	
	$SwimLegShape2D.set_deferred('disabled', true)
	$Fly0LeftLegShape2D.set_deferred('disabled', true)
	$Fly0RightLegShape2D.set_deferred('disabled', true)
	$Fly1HeadShape2D.set_deferred('disabled', true)
	$Fly1LegShape2D.set_deferred('disabled', true)
	if mob_type == 'swim' and mob_frame == 1:
		$SwimLegShape2D.set_deferred('disabled', false)
	elif mob_type == 'fly':
		$BodyShape2D.set_deferred('disabled', true)
		$LeftLegShape2D.set_deferred('disabled', true)
		$RightLegShape2D.set_deferred('disabled', true)
		if mob_frame == 0:
			$Fly0LeftLegShape2D.set_deferred('disabled', false)
			$Fly0RightLegShape2D.set_deferred('disabled', false)
		elif mob_frame == 1:
			$HeadShape2D.set_deferred('disabled', true)
			$Fly1HeadShape2D.set_deferred('disabled', false)
			$Fly1LegShape2D.set_deferred('disabled', false)

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
