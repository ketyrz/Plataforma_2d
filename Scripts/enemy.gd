extends CharacterBody2D
const SPEED = 300.0

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var hit_box: Area2D = $HitBox


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	move_and_slide()

func take_damage():
	anim.play("death")
	hit_box.queue_free()
