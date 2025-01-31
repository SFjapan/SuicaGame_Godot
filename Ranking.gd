extends VBoxContainer
var collection:FirestoreCollection
var doc
@export var ranks:Array[Label]
var count:int = 0
func _ready():
	collection = Firebase.Firestore.collection("Score")
	doc = await collection.get_doc("VRCpHQUdu2HiHd3IJU8J")
	var ranking:Array = doc["document"]["scores"]["arrayValue"]["values"]
	ranking.sort_custom(func(a,b):return int(a["integerValue"]) > int(b["integerValue"]))
	for i in ranking:
		if count > 2:
			break
		ranks[count].text += i["integerValue"]
		count+=1

func update_ranking():
	count = 0
	doc = await collection.get_doc("VRCpHQUdu2HiHd3IJU8J")
	var ranking:Array = doc["document"]["scores"]["arrayValue"]["values"]
	ranking.sort_custom(func(a,b):return a["integerValue"] > b["integerValue"])
	for i in ranking:
		if count > 2:
			break
		ranks[count].text = str(count+1) + "位:" + i["integerValue"]
		count+=1



func _on_firebase_complete_send():
	update_ranking()
	pass # Replace with function body.
