extends RigidBody2D

class_name Fruits

@export var index:int
@export var score:int
@export var rig:RigidBody2D
@export var col:CollisionShape2D

var kumo:Kumo
var col_fruits:Fruits
var isCollision:bool = false
var isDroped:bool = false
var isTouched:bool = false

func _physics_process(delta):
	#マウス移動時ずれるので強制的に付いてくるようにしている
	if not isDroped:
		position = Vector2(0,0)
	
	if isCollision and not kumo.isDetection:
		kumo.score += self.score
		if is_instance_valid(col_fruits):
			col_fruits.queue_free()
		else:
			isCollision = false
			return	
		queue_free()	
		kumo.spawn_fruits(self.index,self.position)
		isCollision = false
	
	if position.y < 202 and isDroped and isTouched:
		kumo.isGame = false
		
func _on_area_2d_area_entered(body):
	isTouched = true
	var parent = body.get_parent()
	if parent is Fruits and not parent.isCollision:
		if self.index == parent.index:
			isCollision = true
			parent.isCollision = true
			col_fruits = parent
			
	pass # Replace with function body.


