#Globalt skript, körs alltid.

extends Node


var Activate: bool = false

#Playerpos är positionen player spawnar på..
#... I nästa rum
var PlayerPos: Vector2

#Används vid ex. takingång
#ger en liten boost upp så man inte faller ner
var PlayerJumpOnEnter: bool
