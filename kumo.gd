extends Node2D

class_name Kumo


const SPEED = 3	#キーボードでの移動スピード
@export var Fruits:Array[PackedScene]	#フルーツの配列

@onready var spwan_pos = $spwanPos	#落とし元位置

@onready var timer = $Timer	#次のフルーツ作成までのタイマー
@onready var detection_timer  = $Detection_timer	#衝突判定のタイマー
@export var next_texture:TextureRect #次のフルーツの画像位置
var fruit:Fruits	#現在のフルーツ
var next_fruits:Fruits	#次のフルーツ
var next_index:int = randi_range(0,4)	#次のフルーツのインデックス
var score:int = 0	#score
var isGame:bool = true	#ゲーム判定
var isDetection:bool = false	#衝突判定
var isDropping:bool = false #現在のフルーツを落とし方どうか

#firebase関連
@onready var backgrpund = $"../Backgrpund"
@onready var firebase = $"../Button/firebase"


func _ready():
	get_next_fruits()
	get_random_fruits()		
	
func _physics_process(delta):
	if not isGame:
		timer.stop()
		firebase.send_data()
		return
	else:	
		if Input.is_action_pressed("ui_left") and position.x > 482:
			position.x -= SPEED		
		if Input.is_action_pressed("ui_right") and position.x < 841:
			position.x += SPEED	
			
		if Input.is_action_just_pressed("ui_accept") or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			if fruit and not isDropping:
				drop()
	
#マウス移動でも操作			
func _input(event):
	if event is InputEventMouseMotion:
		if isGame and (event.position.x < 841 and event.position.x > 482):
			position.x = event.position.x
				
#ランダムで次のフルーツ選択			
func get_next_fruits():
	next_index = 1 # randi_range(0,4)
	next_fruits = Fruits[next_index].instantiate() as Fruits
	var sprite = next_fruits.get_child(0) as Sprite2D
	next_texture.texture = sprite.texture
	
#ランダムで選んだフルーツを出す	
func get_random_fruits():
	if fruit is Fruits:
		return
	next_fruits = null
	fruit = Fruits[next_index].instantiate() as Fruits
	fruit.rig.gravity_scale = 0
	fruit.col.disabled = true
	fruit.kumo = self
	spwan_pos.add_child(fruit)
	fruit.reparent(spwan_pos)
	get_next_fruits()

#進化(チェリー&チェリー=イチゴ)
func spawn_fruits(index:int,pos:Vector2):
	if index >= Fruits.size()-1:
		return
	if not isDetection:
		isDetection = true
		var d = Fruits[index+1].instantiate() as Fruits
		d.kumo = self
		get_parent().add_child(d)
		d.position = pos
		d.isDroped = true
		detection_timer.start()		
		
#落とす		
func drop():
	if not fruit:
		get_random_fruits()
		return
	isDropping = true
	fruit.rig.gravity_scale = 1.0
	fruit.col.disabled = false
	fruit.isDroped = true
	fruit.reparent(get_parent())	
	fruit = null
	timer.start()
	
#リセット	
func reset():	
	if isGame:
		return
	# フルーツ削除
	for i in get_parent().get_children():
		if i is Fruits:
			i.queue_free()
	# 削除完了を待つ
	await get_tree().process_frame
	
	# 変数をリセット
	fruit = null
	next_fruits = null
	score = 0
	next_index = randi_range(0,4)
	isDetection = false
	isDropping = false
	isGame = true

	# 新しいフルーツを設定
	get_next_fruits()
	get_random_fruits()	
	
	
	
#時間経過で次のフルーツ選択	
func _on_timer_timeout():
	get_random_fruits()
	isDropping = false
	pass # Replace with function body.

#一定時間衝突判定削除
func _on_detection_timer_timeout():
	isDetection = false
	pass # Replace with function body.

#スコアが送られたら再開
func _on_firebase_complete_send():
	reset()
	pass # Replace with function body.
