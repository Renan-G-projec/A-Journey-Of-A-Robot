# Ad Maiorem Dei Gloriam!
## AUTOLOAD: SceneManager.
extends CanvasLayer

var transition_duration = 0.5

@onready var transition_rect: ColorRect = %ColorRect

func change_scene_to_file(file: String) -> void:
	assert(FileAccess.file_exists(file), "Error: Trying to change to an unexistent file")
	var scene: PackedScene = load(file) as PackedScene
	if !scene: 
		print_debug("ERROR: Error while loading scene")
		return
	
	var tween: Tween = create_tween()
	var set_progress: Callable = func (val: float) -> void: 
		(transition_rect.material as ShaderMaterial).set_shader_parameter("progress", val)
	tween.tween_method(set_progress, 0.0, 1.0, transition_duration)
	tween.tween_callback(
		func() -> void:
			var new_scene: Node = scene.instantiate()
			get_tree().root.add_child(new_scene)
			_swap_scenes(new_scene)
			
			transition_rect.rotation_degrees += 180
	)
	tween.tween_method(set_progress, 1.0, 0.0, transition_duration)
	
	await tween.finished

func change_scene_to_file_with_loading(file: String, progress_signal: Signal, num_progress_signals: int) -> void:
	assert(num_progress_signals > 0, "Error: Tryed to use a loading screen but no progress is needed. Use SceneManager.change_scene_to_file(file: String) -> void instead.")
	assert(FileAccess.file_exists(file), "Error: Trying to change to an unexistent file")
	var scene: PackedScene = load(file) as PackedScene
	if !scene: 
		print_debug("ERROR: Error while loading scene")
		return
		
	%ProgressBar.max_value = num_progress_signals
	
	var set_progress: Callable = func (val: float) -> void: 
		(transition_rect.material as ShaderMaterial).set_shader_parameter("progress", val)
		
	var tween_fade_in: Tween = create_tween()
	tween_fade_in.tween_method(set_progress, 0.0, 1.0, transition_duration)
	await tween_fade_in.finished
	
	await _fade_progress_bar(1.0).finished
	
	var new_scene: Node = scene.instantiate()
	get_tree().root.add_child(new_scene)
	
	for progress in range(num_progress_signals):
		%ProgressBar.value = progress + 1
		await progress_signal
	
	_swap_scenes(new_scene)
	transition_rect.rotation_degrees += 180
	
	await _fade_progress_bar(0.0).finished
	
	var tween_fade_out: Tween = create_tween()
	tween_fade_out.tween_method(set_progress, 1.0, 0.0, transition_duration)
	await tween_fade_out.finished
	
func _swap_scenes(scene: Node) -> void:
	get_tree().current_scene.free()
	get_tree().current_scene = scene

func _fade_progress_bar(final_val: float) -> Tween:
	var tween: Tween = create_tween()
	tween.tween_property(%ProgressBar, "scale", Vector2(final_val, 1.0), 0.4).set_trans(Tween.TRANS_CUBIC)
	return tween
