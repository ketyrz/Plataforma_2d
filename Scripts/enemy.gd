extends CharacterBody2D
const SPEED = 10.0

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var hit_box: Area2D = $HitBox
@onready var fall_detect: RayCast2D = $fall_detect

var direction = 1

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if !fall_detect.is_colliding():
		direction *= -1
		scale.x *= -1
		
	velocity.x = SPEED * direction

	move_and_slide()

func take_damage():
	direction = 0
	anim.play("death")
	hit_box.queue_free()
