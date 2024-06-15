extends Node

var board_detector: OuijaDetector
var board: OuijaSystem

func init_board(b: OuijaDetector):
	board_detector = b
	board = b.get_node("OuijaSystem")
