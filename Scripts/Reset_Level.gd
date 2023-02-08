extends Node

const serial_res = preload("res://bin/gdserial.gdns")
onready var serial_port = serial_res.new()

var is_port_open = false
var text = ""

signal direita()
signal esquerda()
signal cima()


func _ready():
	open()
	Global.fruits = 0
	pass
	
func _exit_tree():
  close()

func open():
	is_port_open = serial_port.open_port("COM3", 9600)
	print(is_port_open)
	
func write(text):
  serial_port.write_text(text)


func close():
  is_port_open = false
  serial_port.close_port()

func _process(delta):
	if is_port_open:
		var t = serial_port.read_text()
		if t == "d":
			emit_signal("direita")
		
		if t == "e":
			emit_signal("esquerda")
		
		if t == "c":
			emit_signal("cima")
	
