extends Button

signal element_clicked(data)

var element_data : Dictionary
var discovered := true
var count := 0

@onready var atomic_number: Label = $PanelContainer/VBoxContainer/AtomicNumber
@onready var symbol: Label = $PanelContainer/VBoxContainer/Symbol
@onready var counter: Label = $PanelContainer/VBoxContainer/Count

func _ready() -> void:
	add_to_group("elements")
	custom_minimum_size = Vector2(50,50)
	symbol.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	atomic_number.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	counter.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT

func setup(data):
	
	element_data = data

	atomic_number.text = data["atomnummer"]
	symbol.text = data["symbol"]

	update_visual()


func update_visual():

	counter.text = str(count)

	if discovered:
		modulate = category_color(element_data["kategori"])
	else:
		modulate = Color.DIM_GRAY


func category_color(category:String):

	match category:

		"alkalimetall":
			return Color("#ff6666")

		"alkalisk jordartsmetall":
			return Color("#ffb366")

		"övergångsmetall":
			return Color("#ffd966")

		"metall":
			return Color("#d9d9d9")

		"halvmetall":
			return Color("#93c47d")

		"icke-metall":
			return Color("#6fa8dc")

		"halogen":
			return Color("#c27ba0")

		"ädelgas":
			return Color("#d5a6bd")

		"lantanid":
			return Color("#76a5af")

		"aktinid":
			return Color("#45818e")

	return Color.WHITE


func _pressed():
	emit_signal("element_clicked", element_data, discovered, count)
