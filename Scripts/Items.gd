extends Area2D

var fruits = 1

func _on_Items_body_entered(body):
	$anim.play("collected")
	Global.fruits += fruits
	
func _on_anim_animation_finished(anim_name: String):
	if anim_name == "collected":
		queue_free()
