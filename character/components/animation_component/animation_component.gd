extends Node3D
class_name AnimationComponent

@export var animation_tree: AnimationTree
@export var player: Player

var tween: Tween

func _ready() -> void:
	player.set_movement_state.connect(_on_set_movement_state)

func _on_set_movement_state(_movement_state: MovementState):
	if tween:
		tween.kill()
	
	tween = create_tween()
	tween.tween_property(animation_tree, "parameters/movement_blend/blend_position", _movement_state.id, 0.25)
	tween.parallel().tween_property(animation_tree, "parameters/movement_anim_speed/scale", _movement_state.animation_speed, 0.7)
