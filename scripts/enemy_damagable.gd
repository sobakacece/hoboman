extends IDamagable


func hit():
	print("Damaged")
	var tween = create_tween()
	tween.tween_property(get_parent(), "scale", Vector3(2,2,2), 0.2)
	tween.chain().tween_property(get_parent(), "scale", Vector3(1,1,1), 0.2)
	
func kill():
	print("Killed")
