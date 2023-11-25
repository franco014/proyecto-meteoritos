#eventos.gd
extends Node

signal disparo(proyecil)
signal nave_destruida(nave,posicion, explosiones)
signal spawn_meteoritos(posicion,Direccion,tamanio)
signal meteorito_destruido(posicion)
signal nave_en_sector_peligro(centro,camara,tipo_peligro,num_peligros)
signal base_destruida( base , posiciones )
signal spawn_orbital(orbital)
