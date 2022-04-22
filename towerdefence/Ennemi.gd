extends Area2D
onready var Ennemi = self
onready var Variables = get_node("/root/Variables")
onready var Vie = get_node("/root/Control/Label")

func _ready():
	add_to_group("Ennemis")

func _process(_delta):
	Ennemi.global_position.x += 1.5
	if position.x > 896:
#		print("chateau attaqué !")
		Variables.Vie_chateau -= 10
		Vie.text = str(Variables.Vie_chateau)
		queue_free()
