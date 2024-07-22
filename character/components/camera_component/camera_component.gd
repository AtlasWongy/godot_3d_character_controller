extends Node3D
class_name CameraComponent

@onready var yaw_node = new()
@onready var pitch_node = new()
@onready var camera = new()

var yaw: float = 0
var pitch: float =0

var yaw_sensitivity
