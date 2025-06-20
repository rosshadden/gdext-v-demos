import math
import gd

struct Main {
	gd.Node
	gd.Class // HACK: needed for now until I come up with something better
	death_sound    gd.AudioStreamPlayer @[gd.onready: 'DeathSound']
	mob_timer      gd.Timer             @[gd.onready: 'MobTimer']
	music          gd.AudioStreamPlayer @[gd.onready: 'Music']
	score_timer    gd.Timer             @[gd.onready: 'ScoreTimer']
	start_position gd.Marker2D          @[gd.onready: 'StartPosition']
	start_timer    gd.Timer             @[gd.onready: 'StartTimer']

	mob_scene gd.Ref[gd.PackedScene] @[gd.export]
mut:
	hud    HUD    // @[gd.onready: 'HUD']
	player Player // @[gd.onready: 'Player']

	score i64
}

fn (mut s Main) ready_() {
	// TEMP: workaround onready not working great with nested onready nodes
	s.hud = s.get_node_v('HUD').cast_to_v[HUD]()
	s.player = s.get_node_v('Player').cast_to_v[Player]()
}

@[gd.expose]
fn (mut s Main) game_over() {
	s.score_timer.stop()
	s.mob_timer.stop()
	s.hud.show_game_over()
	s.music.stop()
	s.death_sound.play()
}

@[gd.expose]
fn (mut s Main) new_game() {
	// FIX: crash
	// s.get_tree().call_group('mobs', 'queue_free')
	s.get_tree().call_group_v('mobs', 'queue_free')

	s.score = 0
	s.player.start(s.start_position.get_position())
	s.start_timer.start()
	s.hud.update_score(s.score)
	s.hud.show_message('Get Ready')
	s.music.play()
}

@[gd.expose]
fn (mut s Main) on_mob_timer_timeout() {
	// Create a new instance of the Mob scene.
	mut mob := s.mob_scene.get().instantiate_as[gd.RigidBody2D]()

	// Choose a random location on Path2D.
	mut mob_spawn_location := s.get_node_as[gd.PathFollow2D]('MobPath/MobSpawnLocation')
	mob_spawn_location.set_progress(gd.randi())

	// Set the mob's position to a random location.
	mob.set_position(mob_spawn_location.get_position())

	// Set the mob's direction perpendicular to the path direction.
	mut direction := mob_spawn_location.get_rotation() + math.pi / 2

	// Add some randomness to the direction.
	direction += gd.randf_range(-math.pi / 4, math.pi / 4)
	mob.set_rotation(direction)

	// Choose the velocity for the mob.
	velocity := gd.Vector2{f32(gd.randf_range(150.0, 250.0)), 0.0}
	mob.set_linear_velocity(velocity.rotated(direction))

	// Spawn the mob by adding it to the Main scene.
	s.add_child(mob.cast_to[gd.Node]())
}

@[gd.expose]
fn (mut s Main) on_score_timer_timeout() {
	s.score += 1
	s.hud.update_score(s.score)
}

@[gd.expose]
fn (mut s Main) on_start_timer_timeout() {
	s.mob_timer.start()
	s.score_timer.start()
}
