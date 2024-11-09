extends Node

@onready var mesh_instance_3d: MeshInstance3D = $"../NeededForShader/MeshInstance3D"
@onready var brush_size_slider: VSlider = $CanvasLayer/brush_size_slider

func _ready() -> void:
	brush_size_slider.value = mesh_instance_3d.brush_radius.x
	
func _on_brush_size_slider_value_changed(value: float) -> void:
	mesh_instance_3d.brush_radius = Vector2(value, value)
