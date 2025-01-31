extends Node2D
var doc
var collection:FirestoreCollection
var loaded:bool = false
@onready var kumo:Kumo = $"../../Kumo"
signal complete_send
func _ready():
	collection = Firebase.Firestore.collection("Score")
	doc = await collection.get_doc("VRCpHQUdu2HiHd3IJU8J")
	loaded = true
func send_data():
	if not loaded:
		return
	var data:Array = doc["document"]["scores"]["arrayValue"]["values"]
	data.push_back({"integerValue": str(kumo.score) })
	#上位3位以外は削除
	data.sort_custom(func(a,b):return int(a["integerValue"]) > int(b["integerValue"]))
	data = data.slice(0,3)
	doc["document"]["scores"]["arrayValue"]["values"] = data
	await collection.update(doc)
	complete_send.emit()
	
func _on_button_down():
	send_data()
	pass # Replace with function body.
