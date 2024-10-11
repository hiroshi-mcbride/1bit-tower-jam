extends Node


var audio_stream_player: AudioStreamPlayer2D


func _ready() -> void:
	if get_parent() is AudioStreamPlayer2D:
		audio_stream_player = get_parent()


func _on_invoke() -> void:
	if !audio_stream_player.playing:
		audio_stream_player.play()
