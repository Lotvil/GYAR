extends PanelContainer

@onready var title = $VBoxContainer/Title
@onready var number = $VBoxContainer/Number
@onready var mass = $VBoxContainer/Mass
@onready var category = $VBoxContainer/Category
@onready var melting = $VBoxContainer/Melting
@onready var boiling = $VBoxContainer/Boiling
@onready var density = $VBoxContainer/Density
@onready var summary = $VBoxContainer/Summary


func show_element(data, discovered):

	if !discovered:

		title.text = "Okänt" + " (" + data["symbol"] + ")"
		number.text = "Atomnummer: " + data["atomnummer"]
		mass.text = "Okänt"
		category.text = "Okänt"
		melting.text = "Okänt"
		boiling.text = "Okänt"
		density.text = "Okänt"
		summary.text = "Okänt"

		return


	title.text = data["namn"] + " (" + data["symbol"] + ")"
	number.text = "Atomnummer: " + data["atomnummer"]
	mass.text = "Atommassa: " + data["atommassa"]
	category.text = "Kategori: " + data["kategori"]
	melting.text = "Smältpunkt: " + data["smältpunkt_K"] + " K"
	boiling.text = "Kokpunkt: " + data["kokpunkt_K"] + " K"
	density.text = "Densitet: " + data["densitet_kg_m3"] + " kg/m³"

	summary.text = data["sammanfattning"]
