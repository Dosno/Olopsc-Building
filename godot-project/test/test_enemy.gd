extends CharacterBody3D
## Minimal navigation test enemy: follows the node in the "player" group using the
## building navmesh (including the stairs between floors).

@export var speed := 2.5
@onready var agent: NavigationAgent3D = $NavigationAgent3D
var _target: Node3D

func _ready() -> void:
	await get_tree().physics_frame
	await get_tree().physics_frame
	_target = get_tree().get_first_node_in_group("player")

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	if _target:
		agent.target_position = _target.global_position
		if not agent.is_navigation_finished():
			var next := agent.get_next_path_position()
			var dir := next - global_position
			dir.y = 0
			dir = dir.normalized()
			velocity.x = dir.x * speed
			velocity.z = dir.z * speed
			if dir.length() > 0.1:
				look_at(global_position + dir, Vector3.UP)
		else:
			velocity.x = 0
			velocity.z = 0
	move_and_slide()
