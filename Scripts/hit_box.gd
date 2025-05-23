extends Area2D

@onready var character: CharacterBody2D = $".."

func take_damage():
	character.take_damage()
