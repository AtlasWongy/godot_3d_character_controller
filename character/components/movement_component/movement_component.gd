extends Node3D
class_name MovementComponent

@export var player: Player
@export var mesh_root: Node3D
@export var rotation_speed: float = 8
@export var camera: CameraComponent
var direction: Vector3
var velocity: Vector3
var acceleration: float
var speed: float
var cam_rotation: float = 0

func _ready() -> void:
	player.set_movement_state.connect(_on_set_movement_state)
	player.set_movement_direction.connect(_on_set_movement_direction)
	camera.set_cam_rotation.connect(_on_set_cam_rotation)

func _physics_process(delta: float) -> void:
	velocity.x = speed * direction.normalized().x
	velocity.z = speed * direction.normalized().z
	
	player.velocity = player.velocity.lerp(velocity, acceleration * delta)
	player.move_and_slide()
	
	var target_rotation = atan2(direction.x, direction.z) - player.rotation.y
	mesh_root.rotation.y = lerp(mesh_root.rotation.y, target_rotation, rotation_speed * delta)
	
func _on_set_movement_state(_movement_state: MovementState):
	speed = _movement_state.movement_speed
	acceleration = _movement_state.acceleration
	
func _on_set_movement_direction(_movement_direction: Vector3):
	direction = _movement_direction.rotated(Vector3.UP, cam_rotation)
	
func _on_set_cam_rotation(_cam_rotation: float):
	cam_rotation = _cam_rotation

