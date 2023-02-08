extends Area2D



func _ready():
	pass


func _on_goals_body_entered(body):
	if body.name == "Player":
		get_tree().change_scene("res://Prefabs/Win.tscn")
