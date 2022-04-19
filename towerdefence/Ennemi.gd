extends Area2D
onready var Ennemi = self

func _ready():
	add_to_group("Ennemis")

func _process(_delta):
	Ennemi.global_position.x += 2
	if position.x > 896:
		print("chateau attaqué !")
		queue_free()
