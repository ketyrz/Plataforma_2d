extends CharacterBody2D

enum EnemyState {
	walk,
	attack,
	dead
}

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var hit_box: Area2D = $HitBox
@onready var fall_detect: RayCast2D = $fall_detect
@onready var player_detect: RayCast2D = $player_detect
@onready var attack_area: Area2D = $AttackArea

const SPEED = 10.0

var direction = 1
var status: EnemyState

func _ready() -> void:
	go_to_walk()

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	match status:
		EnemyState.walk:
			walk()
		EnemyState.attack:
			attack()
		EnemyState.dead:
			dead()
		
	move_and_slide()

func go_to_walk():
	status = EnemyState.walk
	anim.play("walk")

func walk():
	if !fall_detect.is_colliding():
		direction *= -1
		scale.x *= -1
	
	velocity.x = SPEED * direction
	
	if player_detect.is_colliding():
		go_to_attack()

func go_to_attack():
	status = EnemyState.attack
	anim.play("attack")
	velocity.x = 0

func attack():
	if anim.frame == 2:
		attack_area.process_mode = Node.PROCESS_MODE_INHERIT
	else:
		attack_area.process_mode = Node.PROCESS_MODE_DISABLED

func go_to_dead():
	status = EnemyState.dead
	velocity.x = 0
	anim.play("death")
	hit_box.queue_free()

func dead():
	pass

func take_damage():
	go_to_dead()

func _on_animated_sprite_2d_animation_finished() -> void:
	if anim.animation == "attack":
		go_to_walk()
