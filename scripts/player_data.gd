extends Node

var projectiles_left := 58
var player_health := 100
var dexter_party := true
var jerry_party := true
var zombies_killed := 0
var num_coils := 3
var num_subwoofer := 3
var has_fire_extinguisher := true

var crt_enabled := true
var crt_scanline_setting := 500
var crt_warp_setting := 4.5
var audio_setting := -15.0
var riff_audio_setting := -15.0
var difficulty := 1

var num_shock := 1
var shock_cooldown := 5.0

var damage_radius := 45.0
var knockback_radius := 75.0

func add_special_pickup(special_pickup: Enums.SpecialPickups):
	match (special_pickup):
		Enums.SpecialPickups.Coil:
			num_coils += 1
		Enums.SpecialPickups.Subwoofer:
			num_subwoofer += 1
