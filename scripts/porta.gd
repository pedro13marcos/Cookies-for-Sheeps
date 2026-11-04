extends Area2D

#variaveis
var fechada = true;

#nodes
@onready var parent = $"..";

#inicializacao
func _ready() -> void:
	$aberta.hide();

#desbloqueando a porta
func abrindo():
	fechada = false;
	$aberta.show();
	$fechada.hide();

#checa se já dá pra passar de nivel
func _on_body_entered(body: Node2D) -> void:
	if (body.name == "playerShak"&&fechada == false):
		parent.goNextLevel();
