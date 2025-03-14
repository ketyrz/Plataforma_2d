extends TileMapLayer

@export var speed: float

func _physics_process(delta: float) -> void:
	position.x += speed * delta
	if position.x > 16:
		position.x -= 16
