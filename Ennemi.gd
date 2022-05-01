extends Area2D
signal mort
onready var Ennemi = self
onready var Rocher = get_node_or_null("/root/Control/Rocher")
onready var Variables = get_node("/root/Variables")
onready var Vie = get_node("/root/Control/Label")

func _ready():
	add_to_group("Ennemis")

func _process(_delta):
	Ennemi.global_position.x += 1.5
	if position.x > 896:
		Variables.Vie_chateau -= 10
		Vie.text = str(Variables.Vie_chateau)
		queue_free()
