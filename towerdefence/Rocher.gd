extends Area2D
var speed = 200
onready var Ennemi = get_node("../Ennemi")
onready var Rocher = get_node("../Rocher")
onready var Cible = get_node("../Cible")

func _physics_process(delta):
	if Ennemi.visible == true:
		print(Rocher.global_position,Ennemi.global_position)
		if Ennemi.global_position.x>Rocher.global_position.x+192+48:
			position += transform.x * speed * delta
		elif Ennemi.global_position.x<Rocher.global_position.x+192+48:
			position -= transform.x * speed * delta
		if Ennemi.global_position.y>Rocher.global_position.y+96+48:
			position += transform.y * speed * delta
		elif Ennemi.global_position.y<Rocher.global_position.y+96+48:
			position -= transform.y * speed * delta

func _on_Area2D_body_entered(Ennemi):
	#if Ennemi.is_in_group("mobs"):
		#Ennemi.queue_free()
	Ennemi.queue_free()
	queue_free()
