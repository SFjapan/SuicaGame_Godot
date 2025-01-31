extends RigidBody2D

class_name Fruits

@export var index:int
@export var score:int
@export var rig:RigidBody2D
@export var col:CollisionShape2D
@onready var area_col: CollisionShape2D = $Area2D/CollisionShape2D2

var kumo:Kumo
var col_fruits:Fruits
var isCollision:bool = false
var isDroped:bool = false
var isTouched:bool = false

func _ready() -> void:
	area_col.disabled = true

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

		
func _on_area_2d_area_entered(body):
	isTouched = true

	if not isDroped:
		return  # ここで処理を終了し、ネストを減らす

	var parent = body.get_parent()

	if parent is Fruits and not parent.isCollision and self.index == parent.index:
		isCollision = true
		parent.isCollision = true
		col_fruits = parent
			
