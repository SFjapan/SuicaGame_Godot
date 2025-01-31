extends Label
@export var kumo:Kumo
func _process(delta):
	text = str(kumo.score)
	pass
