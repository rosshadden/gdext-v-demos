import gd

struct HUD {
	gd.CanvasLayer
	gd.Class // HACK: needed for now until I come up with something better

	start_game gd.Signal @[gd.signal]

	message_label gd.Label  @[gd.onready: 'MessageLabel']
	message_timer gd.Timer  @[gd.onready: 'MessageTimer']
	score_label   gd.Label  @[gd.onready: 'ScoreLabel']
	start_button  gd.Button @[gd.onready: 'StartButton']
}

// TODO: these don't need to be exposed
@[gd.expose]
fn (mut s HUD) show_message(text string) {
	s.message_label.set_text(text)
	s.message_label.show()
	s.message_timer.start()
}

@[gd.expose]
fn (mut s HUD) show_game_over() {
	s.show_message('Game Over')
	// TODO: implement nicer awaiting
	// await s.message_timer.timeout
	cb := gd.Callable.new2(&gd.Object(s), gd.StringName.new('once_message_timer_timeout'))
	s.message_timer.connect('timeout', cb)
}

@[gd.expose]
fn (mut s HUD) update_score(score i64) {
	s.score_label.set_text(score.str())
}

@[gd.expose]
fn (mut s HUD) on_start_button_pressed() {
	s.start_button.hide()
	// FIX: crash
	// s.start_game.emit()
	s.emit_signal('start_game')
}

@[gd.expose]
fn (mut s HUD) on_message_timer_timeout() {
	s.message_label.hide()
}

@[gd.expose]
fn (mut s HUD) once_message_timer_timeout() {
	s.message_label.set_text('Dodge the\nCreeps')
	s.message_label.show()
	// TODO: implement nicer awaiting
	// await s.get_tree().create_timer(1).timeout
	cb := gd.Callable.new2(&gd.Object(s), gd.StringName.new('once_create_timer_timeout'))
	s.get_tree().create_timer(1).connect('timeout', cb)
}

@[gd.expose]
fn (mut s HUD) once_create_timer_timeout() {
	s.start_button.show()
}
