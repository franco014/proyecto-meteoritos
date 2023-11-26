#eventos.gd
extends Node

signal disparo(proyecil)
signal nave_destruida(nave,posicion, explosiones)
signal spawn_meteoritos(posicion,Direccion,tamanio)
signal meteorito_destruido(posicion)
signal nave_en_sector_peligro(centro,camara,tipo_peligro,num_peligros)
signal base_destruida( base , posiciones )
signal spawn_orbital(orbital)
signal nivel_iniciado()
signal nivel_terminado()
signal nivel_completado()

##HUD
signal detector_zona_recarga(entrando)
signal cambio_numero_meteoritos(numero)
signal actualizar_tiempo(tiempo_restantes)
signal cambio_energia_laser(energia_max, energia_actual)
signal ocultar_energia_laser()
signal cambio_energia_escudo(energia_max,energia_actual)
signal ocultar_energia_escudo()
signal minimapa_objeto_creado()
signal minimapa_objeto_destruido()
