extends Node3D

signal colour_change

var countryName = []
var countryDict = {}
var nameDict = {}
var dailyDict = {}
var temp
var tempb
var tempc = []

var date = Time.get_date_dict_from_system()

var daily = ""
var dailyNeeded = []

var input = ""
var answered = false
var guesses = 0

var nodePath = "res://Country-nodes.txt"
var CountryScene = preload("res://Country.tscn")

var attributePath = "res://Country-attributes.txt"

func _ready() -> void:
	var file = FileAccess.open(attributePath, FileAccess.READ)
	var countryAttr = []
	while not file.eof_reached():
		var line = file.get_line()
		var attr = line.split(";")
		if attr.size() > 11:
			countryAttr.append(attr)
	countryAttr.remove_at(0)
	
	#file = FileAccess.open("res://Country names.txt", FileAccess.WRITE)
	#for i in countryAttr:
		#file.store_line(i[13].to_lower()+","+i[24].to_lower()+","+i[25].to_lower())
	
	file = FileAccess.open("res://Country names.txt", FileAccess.READ)
	while not file.eof_reached():
		var line = file.get_line()
		countryName.append(line.split(","))
		nameDict[line.split(",")[0]] = countryName.size()-1
	
	#print(countryName)
	
	file = FileAccess.open(nodePath, FileAccess.READ)
	var polygons = {}
	
	while not file.eof_reached():
		var line = file.get_line()
		var parts = line.split(",")
		var shapeid = 0
		var partid = 0
		if parts.size() < 4:
			continue
		shapeid = parts[0].to_int()
		partid = parts[1].to_int()
		var x = parts[2].to_float()
		var y = parts[3].to_float()
		
		if not polygons.has(shapeid):
			polygons[shapeid] = []
		while polygons[shapeid].size() <= partid:
			polygons[shapeid].append([])
		polygons[shapeid][partid].append(Vector2(x, -y))
	
	for shapeid in polygons.keys():
		create_shape(shapeid, polygons[shapeid])
	
	
	
	file = FileAccess.open("res://Country data.txt", FileAccess.READ)
	var countryData = file.get_as_text()
	var list = countryData.split("\n")
	var countryNum = list.size()-1
	for i in countryNum:
		temp = list[i].split(":") #first splits initial country from border countries
		print(temp)
		tempb = temp[1].split(",") #splits borders into individual strings
		for j in tempb:
			if j in nameDict:
				tempc.append(nameDict[j])
		countryDict[temp[0]] = tempc
		if tempb[0] != "none":
			dailyDict[temp[0]] = tempc
		tempc = []
	
	#print (dailyDict)
	if Global.daily:
		seed(int(str(date["day"])+str(date["month"]))+1)
	else:
		randomize()
	
	daily = dailyDict.keys()[randi_range(0,dailyDict.size()-1)]
	$Control/RichTextLabel.text = "[center]What are all the countries that border [b]"+daily+"[/b]?[/center]"
	answered = false;
	dailyNeeded = dailyDict[daily]
	print(daily, nameDict[daily.to_lower()], dailyNeeded)
	
	
	colour_change.emit(nameDict[daily.to_lower()], Color(0,0,1))
	
	#get_tree().get_root().size_changed.connect(update_window)
	
	$Control/RichTextLabel.add_theme_font_size_override("normal_font_size", $Control/RichTextLabel.size.x/400*10+15)
	$Control/RichTextLabel.add_theme_font_size_override("bold_font_size", $Control/RichTextLabel.size.x/400*10+15)
	$Control/LineEdit.add_theme_font_size_override("font_size", $Control/LineEdit.size.x/200*10+6)
	$Control/Wintext.add_theme_font_size_override("normal_font_size", $Control/Wintext.size.x/400*10+15)
	$Control/Correct.add_theme_font_size_override("normal_font_size", $Control/Correct.size.x/400*10+15)
	$Control/Incorrect.add_theme_font_size_override("normal_font_size", $Control/Incorrect.size.x/400*10+15)
	$Control/Nonexistent.add_theme_font_size_override("normal_font_size", $Control/Nonexistent.size.x/400*10+15)
	
	$Control/Wintext.visible = false
	$Control/Correct.visible = false
	$Control/Incorrect.visible = false
	$Control/Nonexistent.visible = false
	

func create_shape(shapeid, parts):
	var shapeArea = CountryScene.instantiate()
	shapeArea.name = str(shapeid)
	add_child(shapeArea)
	
	for partid in range(parts.size()):
		var polygonPoints = parts[partid]
		create_part(shapeArea, partid, polygonPoints)

func create_part(parentNode, partid, points):
	var uniquePoints = points.duplicate()
	
	var polygon = Polygon2D.new()
	polygon.polygon = uniquePoints
	polygon.name = str(partid)
	
	var collisionPolygon = CollisionPolygon2D.new()
	collisionPolygon.polygon = uniquePoints
	collisionPolygon.name = str(partid)
	
	parentNode.add_child(polygon)
	parentNode.add_child(collisionPolygon)

#func update_window():
	#$Control/RichTextLabel.add_theme_font_size_override("normal_font_size", $Control/RichTextLabel.size.x/400*10+15)
	#$Control/RichTextLabel.add_theme_font_size_override("bold_font_size", $Control/RichTextLabel.size.x/400*10+15)
	#$Control/LineEdit.add_theme_font_size_override("font_size", $Control/LineEdit.size.x/200*10+6)

func _on_line_edit_text_submitted(new_text: String) -> void:
	input = new_text
	$Control/LineEdit.text = ""
	var correct = false
	var exist = false
	for i in dailyNeeded:
		if countryName[i].has(input.to_lower()):
			var inputCountry = countryName[i][0]
			dailyNeeded.erase(i)
			print(inputCountry)
			$Control/Correct.visible = true
			$Control/Timer.start()
			correct = true
			guesses += 1
			colour_change.emit(i, Color(0,1,0))
			break
	if !correct:
		for i in countryName:
			if i.has(input.to_lower()):
				$Control/Incorrect.visible = true
				$Control/Timer.start()
				exist = true
				guesses += 1
				colour_change.emit(nameDict[i[0]], Color(1,0,0))
				break
	if !correct and !exist:
		$Control/Nonexistent.visible = true
		$Control/Timer.start()
	
	if dailyNeeded.size()==0:
		$Control/Correct.visible = false
		$Control/Incorrect.visible = false
		$Control/Nonexistent.visible = false
		$Control/Wintext.text = "[center]You win!\nGuesses taken: "+str(guesses)+"[/center]"
		$Control/Wintext.visible = true
		print("You win")


func _on_timer_timeout() -> void:
	$Control/Correct.visible = false
	$Control/Incorrect.visible = false
	$Control/Nonexistent.visible = false


func _on_button_pressed():
	get_tree().change_scene_to_file("res://menu.tscn")

func _on_replay_pressed():
	get_tree().change_scene_to_file("res://Daily.tscn")
