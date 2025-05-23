extends CharacterBody2D

enum PlayerState{
	idle,
	walk,
	jump
}

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@export var max_jump_count = 2

const SPEED = 150.0
const JUMP_VELOCITY = -300.0

var jump_count = 0
var status: PlayerState

func _ready() -> void:
	go_to_idle_state()

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	match status:
		PlayerState.idle:
			idle_state()
		PlayerState.walk:
			walk_state()
		PlayerState.jump:
			jump_state()
	
	move_and_slide()

func go_to_idle_state():
	status = PlayerState.idle
	anim.play("Idle")

func go_to_walk_state():
	status = PlayerState.walk
	anim.play("Walk")

func go_to_jump_state():
	status = PlayerState.jump
	anim.play("Jump")
	velocity.y = JUMP_VELOCITY

func idle_state():
	move()
	
	# Start to walk
	if velocity.x != 0:
		go_to_walk_state()
		return
	
	# Start to jump
	if Input.is_action_just_pressed("Up"):
		go_to_jump_state()
		return

func walk_state():
	move()
	
	if velocity.x == 0:
		go_to_idle_state()
		return
	
	if Input.is_action_just_pressed("jump"):
		go_to_jump_state()
		return

func jump_state():
	move()
	
	if is_on_floor():
		if velocity.x == 0:
			go_to_idle_state()
		else:
			go_to_walk_state()
		return

func move():
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("Left", "Right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if velocity.x > 0:
		anim.flip_h = true
	elif velocity.x < 0:
		anim.flip_h = false

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("DeathZone"):
		call_deferred("ReloadScene")
	elif area.is_in_group("LevelEnd"):
		var next_level = area.next_level
		if next_level:
			call_deferred("LoadScene", next_level)
		else:
			push_error("Próxima fase não definida em end level")
	elif area.is_in_group("Enemy"):
		if velocity.y > 0: # O player matou o inimigo
			area.take_damage() # Deleta o inimigo
			go_to_jump_state()
		else:
			ReloadScene()

func ReloadScene():
	get_tree().reload_current_scene()

func LoadScene(SceneName: String):
	get_tree().change_scene_to_file("res://Scene/" + SceneName + ".tscn")
