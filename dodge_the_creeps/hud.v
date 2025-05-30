import gd

struct HUD {
	gd.CanvasLayer
mut:
	start_game gd.Signal @[gd.signal]

	message_label gd.Label  @[gd.onready: 'MessageLabel']
	message_timer gd.Timer  @[gd.onready: 'MessageTimer']
	score_label   gd.Label  @[gd.onready: 'ScoreLabel']
	start_button  gd.Button @[gd.onready: 'StartButton']
}

fn (mut s HUD) show_message(text string) {
	s.message_label.set_text(text)
	s.message_label.show()
	s.message_timer.start()
}

fn (mut s HUD) show_game_over() {
	s.show_message('Game Over')
	// await s.message_timer.timeout
	s.message_label.set_text('Dodge the\nCreeps')
	s.message_label.show()
	// await s.get_tree().create_timer(1).timeout
	s.start_button.show()
}

fn (mut s HUD) update_score(score int) {
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
