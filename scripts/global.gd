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
const BASE_SIZE := Vector2(1366.0, 768.0);
const RESOLUTIONS: Array[Vector2i] = [
	Vector2i(1280, 720),
	Vector2i(1366, 768),
	Vector2i(1600, 900),
	Vector2i(1920, 1080),
	Vector2i(2560, 1440)
];
var resolution_index: int = 1;
var fullscreen: bool = false;


#Caminho do save - Agora salvando no res ao inves do user pra teste
#const SAVE_PATH = "user://saveGame.json";
const SAVE_PATH = "res://saveGame.json";

# Versao do jogo
const GAME_VERSION: String = "0.8";
const BREAD_TEXTURE: Texture2D = preload("res://sprites/Itens/25ee4e0b-c76a-4506-8a08-0e90b5b211a3.png");
var _cookie_texture: Texture2D = null;

#Vidas agora vão ser salvas aqui pra facilitar criar saves
var vidas = 3;
var currentLevel = "res://nodes/level1.tscn"

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS;
	vidas = 3;
	_register_display_translations();
	load_config();
	apply_display_settings();
	_create_watermark();
	get_tree().root.size_changed.connect(_on_viewport_size_changed);
	get_tree().node_added.connect(_on_node_added);
	call_deferred("_adapt_active_scene");

#func de salvar config
func save_config():
	#cria o dicionário
	var data = {
		"lang": language,
		"layout": layout,
		"resolution_index": resolution_index,
		"fullscreen": fullscreen
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
	if typeof(data) != TYPE_DICTIONARY:
		return;
	
	#Atualiza as variáveis do jogo com os dados carregados
	#Boa prática usar get caso tenha algum erro ao implementar
	language = data.get("lang", language);
	layout = data.get("layout", layout);
	resolution_index = clampi(int(data.get("resolution_index", 1)), 0, RESOLUTIONS.size() - 1);
	fullscreen = bool(data.get("fullscreen", false));
	TranslationServer.set_locale(language);
	
	#Confirma o carregamento
	print("Config loaded!")

func is_cookie_locale() -> bool:
	var loc: String = TranslationServer.get_locale().to_lower();
	return loc.begins_with("en") or loc.begins_with("es");

func get_ammo_texture() -> Texture2D:
	if not is_cookie_locale():
		return BREAD_TEXTURE;
	if _cookie_texture != null:
		return _cookie_texture;
	var abs_path: String = ProjectSettings.globalize_path("res://sprites/Itens/cookie.png");
	if FileAccess.file_exists(abs_path):
		var img := Image.load_from_file(abs_path);
		if img != null:
			_cookie_texture = ImageTexture.create_from_image(img);
	if _cookie_texture == null and ResourceLoader.exists("res://sprites/Itens/cookie.png"):
		_cookie_texture = load("res://sprites/Itens/cookie.png");
	return _cookie_texture if _cookie_texture != null else BREAD_TEXTURE;

func apply_display_settings() -> void:
	var win: Window = get_window();
	if fullscreen:
		if win:
			win.mode = Window.MODE_FULLSCREEN;
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN);
	else:
		if win:
			win.mode = Window.MODE_WINDOWED;
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED);
		var target_size: Vector2i = RESOLUTIONS[clampi(resolution_index, 0, RESOLUTIONS.size() - 1)];
		if win:
			win.size = target_size;
		DisplayServer.window_set_size(target_size);
		var screen_id: int = DisplayServer.window_get_current_screen();
		var screen_pos: Vector2i = DisplayServer.screen_get_position(screen_id);
		var screen_size: Vector2i = DisplayServer.screen_get_size(screen_id);
		var centered_pos: Vector2i = screen_pos + (screen_size - target_size) / 2;
		centered_pos.x = maxi(screen_pos.x, centered_pos.x);
		centered_pos.y = maxi(screen_pos.y, centered_pos.y);
		if win:
			win.position = centered_pos;
		DisplayServer.window_set_position(centered_pos);
	call_deferred("_adapt_active_scene");

func _on_node_added(node: Node) -> void:
	if node == get_tree().current_scene:
		node.ready.connect(_adapt_active_scene, CONNECT_ONE_SHOT);

func _on_viewport_size_changed() -> void:
	_adapt_active_scene();

func _adapt_active_scene() -> void:
	var scene: Node = get_tree().current_scene;
	if not scene:
		return;
	var vp_size: Vector2 = get_viewport().get_visible_rect().size;
	if vp_size.x <= 0 or vp_size.y <= 0:
		return;
	var scale_factor := Vector2(vp_size.x / BASE_SIZE.x, vp_size.y / BASE_SIZE.y);
	if scene.has_node("background"):
		var bg := scene.get_node("background") as TextureRect;
		if bg:
			bg.expand_mode = TextureRect.EXPAND_IGNORE_SIZE;
			bg.stretch_mode = TextureRect.STRETCH_SCALE;
			bg.position = Vector2.ZERO;
			bg.size = vp_size;
	if scene.has_node("porta"):
		var porta := scene.get_node("porta") as Node2D;
		if porta:
			if not porta.has_meta("base_pos"):
				porta.set_meta("base_pos", porta.position);
			var base_pos: Vector2 = porta.get_meta("base_pos");
			porta.position = base_pos * scale_factor;

func _register_display_translations() -> void:
	var entries := {
		"pt": {
			"text_resolution": "Resolução",
			"text_screen_mode": "Modo de Tela",
			"text_windowed": "Janela",
			"text_fullscreen": "Tela Cheia"
		},
		"pt_BR": {
			"text_resolution": "Resolução",
			"text_screen_mode": "Modo de Tela",
			"text_windowed": "Janela",
			"text_fullscreen": "Tela Cheia"
		},
		"en": {
			"text_resolution": "Resolution",
			"text_screen_mode": "Screen Mode",
			"text_windowed": "Windowed",
			"text_fullscreen": "Fullscreen"
		},
		"es": {
			"text_resolution": "Resolución",
			"text_screen_mode": "Modo de Pantalla",
			"text_windowed": "Ventana",
			"text_fullscreen": "Pantalla Completa"
		}
	};
	for loc in entries:
		var tr_obj := Translation.new();
		tr_obj.locale = loc;
		for key in entries[loc]:
			tr_obj.add_message(key, entries[loc][key]);
		TranslationServer.add_translation(tr_obj);
	

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
	if event is InputEventKey:
		controlType = "KBM";
		if event.pressed and not event.echo:
			if event.keycode == KEY_F11 or (event.alt_pressed and (event.keycode == KEY_ENTER or event.keycode == KEY_KP_ENTER)):
				fullscreen = not fullscreen;
				apply_display_settings();
				save_config();
	elif event is InputEventMouse:
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

