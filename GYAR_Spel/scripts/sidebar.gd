extends PanelContainer

@onready var title: Label = $MarginContainer/VBoxContainer/Title
@onready var count: Label = $MarginContainer/VBoxContainer/Count
@onready var number: Label = $MarginContainer/VBoxContainer/Number
@onready var mass: Label = $MarginContainer/VBoxContainer/Mass
@onready var category: Label = $MarginContainer/VBoxContainer/Category
@onready var melting: Label = $MarginContainer/VBoxContainer/Melting
@onready var boiling: Label = $MarginContainer/VBoxContainer/Boiling
@onready var density: Label = $MarginContainer/VBoxContainer/Density
@onready var summary: RichTextLabel = $MarginContainer/VBoxContainer/Summary



func show_element(data, discovered, counts):

	if !discovered:

		title.text = "???" + " (" + data["symbol"] + ")"
		count.text = "Antal: 0"
		
		number.text = "Atomnummer: ???"
		mass.text = "Atommassa: ???"
		category.text = "Kategori: ???"
		melting.text = "Smältpunkt: ???"
		boiling.text = "Kokpunkt: ???"
		density.text = "Densitet: ???"
		summary.text = "?????"

		return


	title.text = data["namn"] + " (" + data["symbol"] + ")"
	count.text = "Antal: " + str(counts)
	
	number.text = "Atomnummer: " + data["atomnummer"]
	mass.text = "Atommassa: " + data["atommassa"]
	category.text = "Kategori: " + data["kategori"]
	melting.text = "Smältpunkt: " + data["smältpunkt_K"] + " K"
	boiling.text = "Kokpunkt: " + data["kokpunkt_K"] + " K"
	density.text = "Densitet: " + data["densitet_kg_m3"] + " kg/m³"
	summary.text = data["sammanfattning"]
