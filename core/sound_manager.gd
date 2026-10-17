## Ad Maiorem Dei Gloriam!
extends Node

var music_volume = 40.0
var sound_effects_volume = 50.0

func start_music() -> void:
	create_tween().tween_property(%SoundManager, "volume_db", -80 + music_volume, 3.0).set_trans(Tween.TRANS_CUBIC)

func resume_music() -> void:
	create_tween().tween_property(%SoundManager, "volume_db", -80, 1.0).set_trans(Tween.TRANS_CUBIC)
