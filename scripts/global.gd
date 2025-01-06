extends Node

var debug_mode = true
var debug_mesh: ImmediateMesh
var material: StandardMaterial3D
var lines_to_draw: Array[Dictionary] = []

func _ready():
	debug_mesh = ImmediateMesh.new()
	material = StandardMaterial3D.new()
	material.albedo_color = Color.ROYAL_BLUE
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.vertex_color_use_as_albedo = true
	
	var mesh_instance = MeshInstance3D.new()
	mesh_instance.mesh = debug_mesh
	mesh_instance.material_override = material
	add_child(mesh_instance)
	

func _process(delta: float) -> void:
	update_debug_lines()
	#call_deferred("_late_update")

func _late_update():
	clear_debug_lines()

func update_debug_lines():
	debug_mesh.clear_surfaces()
	debug_mesh.surface_begin(Mesh.PRIMITIVE_LINES)
	
	for line in lines_to_draw:
		debug_mesh.surface_set_color(line.color)
		debug_mesh.surface_add_vertex(line.start_pos)
		debug_mesh.surface_add_vertex(line.end_pos)
	
	debug_mesh.surface_end()
	lines_to_draw.clear()

func add_debug_line(start_pos: Vector3, end_pos: Vector3, color: Color = Color.ROYAL_BLUE):
	lines_to_draw.append({
		"start_pos": start_pos,
		"end_pos": end_pos,
		"color": color
	})

func clear_debug_lines():
	lines_to_draw.clear()
	#debug_mesh.clear_surfaces()

func debug(data):
	if not debug_mode:
		return
		
	if data is RayCast3D:
		if data.is_enabled():
			var start_pos = data.global_position
			var end_pos = data.global_position + data.target_position
			add_debug_line(start_pos, end_pos)
			
	elif data is Array and data.size() == 2:
		if data[0] is Vector3 and data[1] is Vector3:
			add_debug_line(data[0], data[1])
