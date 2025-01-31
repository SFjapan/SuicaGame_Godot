extends Node2D
var doc
var collection:FirestoreCollection
@onready var kumo:Kumo = $"../../Kumo"
signal complete_send
func _ready():
	collection = Firebase.Firestore.collection("Score")
	doc = await collection.get_doc("VRCpHQUdu2HiHd3IJU8J")

func send_data():
	var data:Array = doc["document"]["scores"]["arrayValue"]["values"]
	data.push_back({"integerValue": str(kumo.score) })
	doc["document"]["scores"]["arrayValue"]["values"] = data
	await collection.update(doc)
	complete_send.emit()
	
func _on_button_down():
	send_data()
	pass # Replace with function body.
