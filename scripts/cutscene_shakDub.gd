extends Control

# Tabela de legendas: [tempo_inicio, tempo_fim, chave_traducao]
const SUBTITLES = [
	[0.06, 4.30, "cutscene_1"],
	[4.43, 8.80, "cutscene_2"],
	[9.26, 16.00, "cutscene_3"],
	[16.75, 25.50, "cutscene_4"],
	[26.06, 33.50, "cutscene_5"],
	[34.42, 42.50, "cutscene_6"],
	[43.63, 50.50, "cutscene_7"],
	[51.85, 57.50, "cutscene_8_1"],
	[57.50, 66.00, "cutscene_8_2"]
]

var subtitle_layer: CanvasLayer
var subtitle_panel: PanelContainer
var subtitle_label: Label

func _ready() -> void:
	$cutsceneMenu.layer = 10;
	$cutsceneMenu.hide();
	_setup_localized_audio();
	_setup_subtitles();
	$AnimationPlayer.play("cutscene");
	
func _process(delta: float) -> void:
	if Input.is_anything_pressed():
		pularCutscene();
	_update_subtitles();

func _setup_localized_audio() -> void:
	var loc = TranslationServer.get_locale();
	var lang_code = "pt";
	if loc.begins_with("en"):
		lang_code = "en";
	elif loc.begins_with("es"):
		lang_code = "es";
	
	if lang_code == "pt":
		return;
		
	var audio_map = {
		$Recording: "res://sound/cutscene/" + lang_code + "/Recording.mp3",
		$"Recording(2)": "res://sound/cutscene/" + lang_code + "/Recording (2).mp3",
		$"Recording(3)": "res://sound/cutscene/" + lang_code + "/Recording (3).mp3",
		$"Recording(4)": "res://sound/cutscene/" + lang_code + "/Recording (4).mp3",
		$"Recording(5)": "res://sound/cutscene/" + lang_code + "/Recording (5).mp3",
		$"Recording(6)": "res://sound/cutscene/" + lang_code + "/Recording (6).mp3",
		$"Recording(7)": "res://sound/cutscene/" + lang_code + "/Recording (7).mp3",
		$"Recording(8)": "res://sound/cutscene/" + lang_code + "/Recording (8).mp3",
	};
	
	for player in audio_map:
		var path = audio_map[player];
		if ResourceLoader.exists(path):
			player.stream = load(path);

func _setup_subtitles() -> void:
	subtitle_layer = CanvasLayer.new()
	subtitle_layer.layer = 2
	add_child(subtitle_layer)
	
	subtitle_panel = PanelContainer.new()
	subtitle_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	subtitle_layer.add_child(subtitle_panel)
	
	# Posicionamento centralizado na parte inferior
	subtitle_panel.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_WIDE)
	subtitle_panel.offset_left = 120.0
	subtitle_panel.offset_right = -120.0
	subtitle_panel.offset_top = -140.0
	subtitle_panel.offset_bottom = -30.0
	
	var style = StyleBoxFlat.new()
	style.bg_color = Color(0.0, 0.0, 0.0, 0.72)
	style.set_corner_radius_all(12)
	style.content_margin_left = 24.0
	style.content_margin_right = 24.0
	style.content_margin_top = 12.0
	style.content_margin_bottom = 12.0
	subtitle_panel.add_theme_stylebox_override("panel", style)
	
	subtitle_label = Label.new()
	subtitle_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	subtitle_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	subtitle_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	subtitle_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	# Estilo do texto
	subtitle_label.add_theme_font_size_override("font_size", 26)
	subtitle_label.add_theme_color_override("font_color", Color(1.0, 1.0, 1.0, 1.0))
	subtitle_label.add_theme_color_override("font_shadow_color", Color(0.0, 0.0, 0.0, 0.9))
	subtitle_label.add_theme_constant_override("shadow_offset_x", 2)
	subtitle_label.add_theme_constant_override("shadow_offset_y", 2)
	subtitle_label.add_theme_color_override("font_outline_color", Color(0.0, 0.0, 0.0, 0.8))
	subtitle_label.add_theme_constant_override("outline_size", 4)
	
	subtitle_panel.add_child(subtitle_label)
	subtitle_panel.hide()

func _update_subtitles() -> void:
	if not $AnimationPlayer.is_playing():
		if subtitle_panel:
			subtitle_panel.hide()
		return
	var time = $AnimationPlayer.current_animation_position
	for cue in SUBTITLES:
		if time >= cue[0] and time < cue[1]:
			var txt = tr(cue[2])
			if subtitle_label.text != txt:
				subtitle_label.text = txt
			subtitle_panel.show()
			return
	subtitle_panel.hide()


func pularCutscene():
	if subtitle_panel:
		subtitle_panel.hide();
	get_tree().paused = true;
	$cutsceneMenu.show();
	$cutsceneMenu/VBoxContainer/Continuar.grab_focus();
	

func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	get_tree().change_scene_to_file("res://nodes/level1.tscn");


func _on_continuar_button_up() -> void:
	get_tree().paused = false;
	$cutsceneMenu.hide();
	


func _on_pular_button_up() -> void:
	$AnimationPlayer.stop();
	get_tree().paused = false;
	_on_animation_player_animation_finished("custscene");


func _on_menu_button_up() -> void:
	get_tree().paused = false;
	get_tree().change_scene_to_file("res://nodes/menu.tscn");


func _on_sair_button_up() -> void:
	get_tree().quit();
