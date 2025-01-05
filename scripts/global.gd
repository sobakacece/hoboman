extends Node

var debug_mode = true
var debug_mesh: ImmediateMesh
var material: StandardMaterial3D

func _ready():
	debug_mesh = ImmediateMesh.new()
	material = StandardMaterial3D.new()
	material.albedo_color = Color.RED
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.vertex_color_use_as_albedo = true
	
	var mesh_instance = MeshInstance3D.new()
	mesh_instance.mesh = debug_mesh
	mesh_instance.material_override = material
	add_child(mesh_instance)

func draw_line(start_pos: Vector3, end_pos: Vector3):
	debug_mesh.clear_surfaces()
	debug_mesh.surface_begin(Mesh.PRIMITIVE_LINES)
	
	debug_mesh.surface_set_color(Color.RED)
	debug_mesh.surface_add_vertex(start_pos)
	debug_mesh.surface_add_vertex(end_pos)
	
	debug_mesh.surface_end()

func debug(data):
	if not debug_mode:
		return
		
	if data is RayCast3D:
		if data.is_enabled():
			var start_pos = data.global_position
			var end_pos = data.global_position + data.target_position
			draw_line(start_pos, end_pos)
			
	elif data is Array and data.size() == 2:
		if data[0] is Vector3 and data[1] is Vector3:
			draw_line(data[0], data[1])
