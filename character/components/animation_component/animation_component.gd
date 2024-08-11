extends Node3D
class_name AnimationComponent

@export var animation_tree: AnimationTree
@export var player: Player

var tween: Tween

func _ready() -> void:
	player.set_movement_state.connect(_on_set_movement_state)
	player.set_crouch_state.connect(_on_set_crouch_state)
	player.set_emoting_state.connect(_on_set_emoting_state)
	player.set_default_state.connect(_on_set_default_state)

func _on_set_movement_state(_movement_state: MovementState):
	if tween:
		tween.kill()
	
	tween = create_tween()
	tween.tween_property(animation_tree, "parameters/movement_blend/blend_position", _movement_state.id, 0.25)
	tween.parallel().tween_property(animation_tree, "parameters/movement_anim_speed/scale", _movement_state.animation_speed, 0.7)

func _on_set_crouch_state(_crouch_state: bool):
	
	_crouch_state = !_crouch_state
	
	if _crouch_state:
		animation_tree["parameters/transition/transition_request"] = "crouch"
		
		if tween:
			tween.kill()
			
		tween = create_tween()
		tween.tween_property(animation_tree, "parameters/crouch_blend/blend_position", 1, 0.8)
		
	else:
		if tween:
			tween.kill()
			
		tween = create_tween()
		await tween.tween_property(animation_tree, "parameters/crouch_blend/blend_position", 0, 0.8).finished
		animation_tree["parameters/transition/transition_request"] = "movement"
		
func _on_set_emoting_state(_emote_state: bool):
	animation_tree["parameters/transition/transition_request"] = "movement"
	animation_tree["parameters/emote_one_shot/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE
	
func _on_set_default_state():
	animation_tree["parameters/emote_one_shot/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_ABORT
	animation_tree["parameters/transition/transition_request"] = "movement"
