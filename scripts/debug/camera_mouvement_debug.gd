extends Node2D
class_name CameraDebug

var x: float
var y: float
var size_x: float
var size_y: float
var color: Color
var default_font : Font = ThemeDB.fallback_font;

func _draw_camera_zone(x: float, y: float, size_x: float, size_y: float, c: Color):
	self.x = x
	self.y = y
	self.size_x = size_x
	self.size_y = size_y
	self.color = c
	queue_redraw()  # Schedule a redraw

func _draw():
	draw_rect(Rect2(x, y, size_x, size_y), color, false, 1.0)
	draw_string(default_font, Vector2(20, 130), "GODOT", HORIZONTAL_ALIGNMENT_CENTER, 90, 22)
