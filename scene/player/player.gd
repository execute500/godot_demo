extends Area2D

signal hit

@export var speed = 400
var screen_size

func _ready() -> void:
		screen_size = get_viewport_rect().size
		print_debug('屏幕大小: ' + str(screen_size))
		hide()

func _process(delta: float) -> void:
		var velocity = Vector2.ZERO
		if Input.is_action_pressed("move_right"):
				velocity.x += 1
		if Input.is_action_pressed("move_left"):
				velocity.x -= 1
		if Input.is_action_pressed("move_down"):
				velocity.y += 1
		if Input.is_action_pressed("move_up"):
				velocity.y -= 1

		if velocity.length() > 0:
				velocity = velocity.normalized() * speed
				$AnimatedSprite2D.play()
		else:
				$AnimatedSprite2D.stop()

		position += velocity * delta
		position = position.clamp(Vector2.ZERO, screen_size)

		if velocity.x != 0:
				$AnimatedSprite2D.animation = "walk"
				$AnimatedSprite2D.flip_h = velocity.x < 0
		elif velocity.y != 0:
				$AnimatedSprite2D.animation = "up"


@warning_ignore("unused_parameter")
func _on_body_entered(body) -> void:
		hide()
		hit.emit()

func start(pos: Vector2) -> void:
		position = pos
		show()
