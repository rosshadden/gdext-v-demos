import gd
import math

struct Player {
	gd.Area2D
	gd.Class
	hit gd.Signal @[gd.signal]

	sprite gd.AnimatedSprite2D @[gd.onready: 'AnimatedSprite2D']
	trail  gd.GPUParticles2D   @[gd.onready: 'Trail']
mut:
	// How fast the player will move (pixels/sec).
	speed i64 = 400 @[gd.export]

	// Size of the game window.
	screen_size gd.Vector2
}

fn (mut s Player) ready_() {
	s.screen_size = s.get_viewport_rect().size
	s.hide()
}

fn (mut s Player) process_(delta f64) {
	// The player's movement vector.
	mut velocity := gd.Vector2{}
	input := gd.Input.singleton()
	if input.is_action_pressed('move_right') {
		velocity.x += 1
	}
	if input.is_action_pressed('move_left') {
		velocity.x -= 1
	}
	if input.is_action_pressed('move_down') {
		velocity.y += 1
	}
	if input.is_action_pressed('move_up') {
		velocity.y -= 1
	}

	if velocity.length() > 0 {
		velocity = velocity.normalized().mul_i64(s.speed)
		s.sprite.play()
	} else {
		s.sprite.stop()
	}

	mut position := s.get_position()
	position += velocity.mul_f64(delta)
	position = position.clamp(gd.vector2_zero, s.screen_size)
	s.set_position(position)

	if velocity.x != 0 {
		s.sprite.set_animation('right')
		s.sprite.set_flip_v(false)
		s.trail.set_rotation(0)
		s.sprite.set_flip_h(velocity.x < 0)
	} else if velocity.y != 0 {
		s.sprite.set_animation('up')
		s.set_rotation(if velocity.y > 0 { math.pi } else { 0 })
	}
}

@[gd.expose]
fn (mut s Player) start(pos gd.Vector2) {
	s.set_position(pos)
	s.set_rotation(0)
	s.show()
	s.get_node_as[gd.CollisionShape2D]('CollisionShape2D').set_disabled(false)
}

@[gd.expose]
fn (mut s Player) on_body_entered(body gd.Node2D) {
	// Player disappears after being hit.
	s.hide()
	s.hit.emit()
	// Must be deferred as we can't change physics properties on a physics callback.
	s.get_node_as[gd.CollisionShape2D]('CollisionShape2D').set_deferred('disabled', gd.Variant.from_bool(true))
}
