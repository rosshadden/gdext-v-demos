module scenes

import gd

pub struct Lab {
	gd.Node3D
	gd.Class // HACK: needed for now until I come up with something better
	model gd.CSGShape3D          @[gd.onready]
}

fn (mut s Lab) process_(delta f64) {
	s.model.rotate(gd.Vector3.left(), delta)
	s.model.rotate(gd.Vector3.up(), delta)
}
