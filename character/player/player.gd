extends CharacterBody3D
class_name Player

signal set_movement_state(_movement_state: MovementState)
signal set_movement_direction(_movement_direction: Vector3)
signal set_crouch_state(_crouch_state: bool)
signal set_emoting_state(_emote_state: bool)
signal set_default_state()

@export var movement_states: Dictionary

var movement_direction: Vector3
var is_crouching: bool = false
var is_emoting: bool = false

func _input(event):
	if event.is_action("movement"):
		set_default_state.emit()
		
		movement_direction.x = Input.get_action_strength("left") - Input.get_action_strength("right")
		movement_direction.z = Input.get_action_strength("forward") - Input.get_action_strength("backwards")
		
		if is_movement_ongoing():
			if Input.is_action_pressed("sprint"):
				set_movement_state.emit(movement_states["sprint"])
			else:
				set_movement_state.emit(movement_states["run"])
		else:
			set_movement_state.emit(movement_states["idle"])
	
	if event.is_action_pressed("crouch"):
		set_crouch_state.emit(is_crouching)
		is_crouching = !is_crouching
		
	if event.is_action_pressed("emote"):
		set_emoting_state.emit(is_emoting)
		is_emoting = !is_emoting
		
func _ready() -> void:
	set_movement_state.emit(movement_states["idle"])
	
func _physics_process(delta):
	if is_movement_ongoing():
		set_movement_direction.emit(movement_direction)
	#
func is_movement_ongoing() -> bool:
	return abs(movement_direction.x) > 0 or abs(movement_direction.z) > 0

