extends CharacterBody2D

@onready var anime: AnimatedSprite2D = $AnimatedSprite2D

const SPEED = 65.0
const JUMP_VELOCITY = -300.0

@onready var anim: AnimatedSprite2D = $Anime
@export var max_jump_count = 2

var jump_count = 0

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		jump_count = 0
		if velocity.x != 0:
			anime.play("Walk")
		else:
			anime.play("Idle")
			

	# Handle jump.
	if Input.is_action_just_pressed("Up") and jump_count < max_jump_count: 
		velocity.y = JUMP_VELOCITY
		jump_count += 1
		anime.play("Jump")

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("Left", "Right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	if velocity.x > 0:
		anime.flip_h = true
	elif velocity.x < 0:
		anime.flip_h = false
		
		
	move_and_slide()


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("DeathZone"):
		call_deferred("ReloadScene")
	elif area.is_in_group("LevelEnd"):
		var next_level = area.next_level
		if next_level:
			call_deferred("LoadScene", next_level)
		else:
			push_error("Próxima fase não definida em end level")
		
func ReloadScene():
	get_tree().reload_current_scene()
	
func LoadScene(SceneName: String):
	get_tree().change_scene_to_file("res://Scene/" + SceneName + ".tscn")
