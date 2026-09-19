extends GPUParticles2D


@onready var sprite: AnimatedSprite2D = $"../Pivot/Sprite2D"

func _process(delta: float) -> void:
    if emitting:
        var material: ShaderMaterial = process_material as ShaderMaterial
        if material:
            material.set_shader_parameter("targetPos", sprite.global_position)
            material.set_shader_parameter("initial_velocity", Vector2.from_angle(deg_to_rad(randi_range(0, 360))) * 48)
            material.set_shader_parameter("initial_offset", Vector2(randi_range(-8, 8), randi_range(-4, 4)))
