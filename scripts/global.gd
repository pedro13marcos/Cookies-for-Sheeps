extends Node

#Salvando as Cenas para me ajudar no futuro
var prevScenePath: String = "";
var nextScenePath: String = "";

#Caminho do config
const CONF_PATH = "res://confGame.json";

#Variaveis de config
var language = TranslationServer.get_locale();
var layout = "Auto";
var controlType = "KBM";


#Caminho do save - Agora salvando no res ao inves do user pra teste
#const SAVE_PATH = "user://saveGame.json";
const SAVE_PATH = "res://saveGame.json";

# Versao do jogo
const GAME_VERSION: String = "0.3";

#Vidas agora vão ser salvas aqui pra facilitar criar saves
var vidas = 3;
var currentLevel = "res://nodes/level1.tscn"

func _ready() -> void:
	vidas = 3;
	load_config();
	_create_watermark();

#func de salvar config
func save_config():
	#cria o dicionário
	var data = {
		"lang":language,
		"layout": layout
	}
	
	#Abre o arquivo
	var file = FileAccess.open(CONF_PATH,FileAccess.WRITE);
	
	#Transformar o array em JSON
	var json_string = JSON.stringify(data);
	
	#guarda e salva o texto
	file.store_string(json_string);
	print("Config saved successfully!");
	
#funcao de carregar config
func load_config():
	if not FileAccess.file_exists(CONF_PATH):
		print("File not found!");
		return;
		
	#Abre o arquivo para leitura
	var file = FileAccess.open(CONF_PATH,FileAccess.READ);
	
	#Pega o texto do arquivo
	var json_string = file.get_as_text()
	
	#Converte o texto de volta pra dicionário em array
	var data = JSON.parse_string(json_string);
	
	#Atualiza as variáveis do jogo com os dados carregados
	#Boa prática usar get caso tenha algum erro ao implementar
	language = data.get("lang");
	layout = data.get("layout");
	
	#Confirma o carregamento
	print("Config loaded!")
	

#função de salvar o jogo em arquivo
func save_game():
	#Cria um dicionário de dados para ser transformado em json:
	var data = {
		"vida": vidas,
		"lvl": currentLevel,
		"lng": language
	}
	
	#Abre o arquivo
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE);

	#Transforma o array data em JSON
	var json_string = JSON.stringify(data);
	
	#Guarda o texto no arquivo e fecha automaticamente
	file.store_string(json_string)
	print("Game successfully saved!");
	
#Função de carregar o jogo
func load_game():
	#Checa se o arquivo existe antes de tentar ler:
	if not FileAccess.file_exists(SAVE_PATH):
		print("Save file not found");
		return;
		
	#Abre o arquivo para leitura
	var file = FileAccess.open(SAVE_PATH,FileAccess.READ);
	
	#Pega o texto do arquivo
	var json_string = file.get_as_text()
	
	#Converte o texto de volta pra dicionário em array
	var data = JSON.parse_string(json_string);
	
	#Atualiza as variáveis do jogo com os dados carregados
	#Boa prática usar get caso tenha algum erro ao implementar
	vidas = data.get("vida",3);
	currentLevel = data.get("lvl", "res://nodes/level1.tscn");
	
	#Confirma o carregamento
	print("Game loaded!")
	get_tree().change_scene_to_file(currentLevel);

#Checa se tem um arquivo de save
func checkSave():
	if FileAccess.file_exists(Global.SAVE_PATH):
		return true;
	else:
		return false;
	
#Checar o tipo do controle
func _input(event: InputEvent) -> void:
	if event is InputEventKey or event is InputEventMouse:
		controlType = "KBM";
	elif event is InputEventJoypadButton:
		#Pega o id da fabricante. Não achei tabela de conversão então tive que fazer no teste aqui
		match Input.get_joy_info(0)["vendor_id"]:
			var g when "1356" in g:
				controlType = "PS";
			var g when "1406" in g:
				controlType = "NS"
			var g when "1118" in g:
				controlType = "XB";
			_:
				controlType = "GN"
				pass;

func _create_watermark() -> void:
	# Persistent canvas layer on top of all scenes
	var canvas = CanvasLayer.new()
	canvas.name = "WatermarkLayer"
	canvas.layer = 120 # Top-most layer above menus and HUD
	add_child(canvas)
	
	var label = Label.new()
	label.name = "WatermarkLabel"
	label.text = "pre-alpha " + GAME_VERSION
	
	# Add child to the CanvasLayer first so anchors calculate against the viewport
	canvas.add_child(label)
	
	# Bottom wide alignment
	label.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_WIDE)
	label.offset_top = -36.0
	label.offset_bottom = -8.0
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_BOTTOM
	
	# Clean, semi-transparent watermark styling
	label.add_theme_font_size_override("font_size", 14)
	label.add_theme_color_override("font_color", Color(1.0, 1.0, 1.0, 0.65))
	label.add_theme_color_override("font_shadow_color", Color(0.0, 0.0, 0.0, 0.8))
	label.add_theme_constant_override("shadow_offset_x", 1)
	label.add_theme_constant_override("shadow_offset_y", 1)
	
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE

