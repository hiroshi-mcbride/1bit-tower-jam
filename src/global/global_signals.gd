extends Node


# These signals are used from other classes
@warning_ignore("unused_signal") signal game_started
@warning_ignore("unused_signal") signal game_quit
@warning_ignore("unused_signal") signal level_changed(new_level: PackedScene)
@warning_ignore("unused_signal") signal menu_changed(new_menu: PackedScene)
@warning_ignore("unused_signal") signal level_reset
@warning_ignore("unused_signal") signal volume_changed(type: AudioManager.VolumeType, value: float)
@warning_ignore("unused_signal") signal game_won
