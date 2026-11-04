extends Area2D

#variaveis
var fechada = true;

#nodes
@onready var parent = $"..";

#inicializacao
func _ready() -> void:
	_setup_localized_audio();
	$"bate nele".play(0.6);
	$aberta.hide();

func _setup_localized_audio() -> void:
	var loc = TranslationServer.get_locale();
	var lang_code = "pt";
	if loc.begins_with("en"):
		lang_code = "en";
	elif loc.begins_with("es"):
		lang_code = "es";
		
	if lang_code == "pt":
		return;
		
	var path_socorro = "res://sound/dub/" + lang_code + "/To com medo.mp3";
	var path_bate = "res://sound/dub/" + lang_code + "/bate nele.mp3";
	if ResourceLoader.exists(path_socorro):
		$socorro.stream = load(path_socorro);
	if ResourceLoader.exists(path_bate):
		$"bate nele".stream = load(path_bate);

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
