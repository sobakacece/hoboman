extends Node
var normal

func _physics_process(delta: float) -> void:
	if get_parent() and $RayCast3D.is_colliding():
		normal = $RayCast3D.get_collision_normal()
		print($RayCast3D.get_collider())
		var parent_transform = get_parent().global_transform
		var xform = align_with_y(parent_transform, normal)
		get_parent().global_transform = parent_transform.interpolate_with(xform, 0.2)

func align_with_y(xform: Transform3D, new_y: Vector3) -> Transform3D:
	xform.basis.y = new_y
	xform.basis.x = -xform.basis.z.cross(new_y)
	xform.basis = xform.basis.orthonormalized()
	return xform
