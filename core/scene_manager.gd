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
	
	print(get_tree().current_scene.name)
	# preloads in memory
	
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
	print(get_tree().current_scene.name)

func _swap_scenes(scene: Node) -> void:
	get_tree().current_scene.free()
	get_tree().current_scene = scene
