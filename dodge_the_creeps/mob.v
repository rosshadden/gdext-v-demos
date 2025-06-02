import gd
import rand

struct Mob {
	gd.RigidBody2D
	gd.Class
}

fn (s &Mob) ready_() {
	sprite := s.get_node_as[gd.AnimatedSprite2D]('AnimatedSprite2D')
	anim_names := sprite.get_sprite_frames().get_animation_names()
	mut mob_types := []string{}
	for a in 0 .. anim_names.size() {
		mob_types << anim_names.get(a).to_v()
	}
	idx := rand.i64n(mob_types.len - 1) or { 0 }
	sprite.set_animation(mob_types[idx])
	sprite.play()
}

@[gd.expose]
fn (mut s Mob) on_visibility_notifier_2d_screen_exited() {
	s.queue_free()
}
