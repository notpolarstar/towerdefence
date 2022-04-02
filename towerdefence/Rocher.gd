extends Area2D
var speed = 10
onready var Ennemi = get_node("../Ennemi")
onready var Rocher = self
onready var Cible = get_node("../Cible")
onready var pos_depart = Vector2(Rocher.global_position.x+192+48,Rocher.global_position.y+96+48)

func _physics_process(delta):
	var Ennemi = get_node("../Ennemi")
	if Ennemi!=null and Ennemi.visible == true:
		var vecteur = Ennemi.global_position-Vector2(Rocher.global_position.x+192+48,Rocher.global_position.y+96+48)
		position += speed*vecteur.normalized()

func _on_Rocher_area_entered(Ennemi):
	Ennemi.queue_free()
	$Caillou.visible = false
	set_deferred("monitoring",false)
	set_deferred("monitorable",false)

func _on_Timer_timeout():
	print("timer")
	Rocher.global_position = pos_depart
	print(Rocher.position)
	$Caillou.visible = true
	set_deferred("monitoring",true)
	set_deferred("monitorable",true)
	$Timer.start()
