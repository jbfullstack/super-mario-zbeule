extends Node2D
class_name CameraDebug

var posx: float
var posy: float
var sizex: float
var sizey: float
var color: Color
var default_font : Font = ThemeDB.fallback_font;

func _draw_camera_zone(px: float, py: float, sx: float, sy: float, c: Color):
	self.posx = posx
	self.posx = posy
	self.sizex = sizex
	self.sizey = sizey
	self.color = c
	queue_redraw()  # Schedule a redraw

func _draw():
	draw_rect(Rect2(posx, posy, sizex, sizey), color, false, 1.0)
	draw_string(default_font, Vector2(20, 130), "GODOT", HORIZONTAL_ALIGNMENT_CENTER, 90, 22)
