module services

import gd
import log

pub struct Debug {
	gd.Node
}

fn (s &Debug) ready_() {
	log.info('service ready: ${s.get_name()}')
}

fn (mut s Debug) unhandled_key_input_(event gd.InputEvent) {
	if !event.is_action_type() || !event.is_pressed() {
		return
	}

	match true {
		event.is_action('game.quit') {
			s.get_tree().quit()
		}
		event.is_action('game.restart') {
			s.get_tree().reload_current_scene()
		}
		event.is_action('game.debug') {
			gd.prints(gd.String.new('test').to_variant(), gd.String.new('ing').to_variant())
		}
		else {}
	}
}
