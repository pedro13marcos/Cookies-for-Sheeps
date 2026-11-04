extends Area2D

#variaveis
var fechada = true;

#nodes
@onready var parent = $"..";

#inicializacao
func _ready() -> void:
	$"bate nele".play(0.6);
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


func _on_pedido_socorro_timeout() -> void:
	randomize();
	if randi_range(0,1):
		$"bate nele".play(0.6);
	else: $socorro.play(0.8);
	$pedidoSocorro.start();
