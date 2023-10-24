extends Node2D

func _ready() -> void:
	Eventos.connect("disparo",self,"_on_disparo")

func _on_disparo(proyectil:proyectil) ->void:
	add_child(proyectil)
