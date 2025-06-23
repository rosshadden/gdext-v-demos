import gd
import gd.gdext
import scenes
import services

pub fn init_gd(v voidptr, l gd.GDExtensionInitializationLevel) {
	if l == .initialization_level_scene {
		gd.register_class[scenes.Lab]('Node3D')
		gd.register_class[services.Debug]('Node')
	}
}

pub fn deinit_gd(v voidptr, l gd.GDExtensionInitializationLevel) {
	if l == .initialization_level_scene {
	}
}

@[export: 'gdext_v_init']
fn init_gdext(gpaddr fn (&i8) gd.GDExtensionInterfaceFunctionPtr, clp gd.GDExtensionClassLibraryPtr, mut gdnit gd.GDExtensionInitialization) gd.GDExtensionBool {
	gdext.setup(gpaddr, clp)
	gdnit.initialize = init_gd
	gdnit.deinitialize = deinit_gd
	return 1
}
