import gd
import log

pub fn init_gd(v voidptr, l gd.GDExtensionInitializationLevel) {
	if l == .initialization_level_scene {
		gd.register_class[Main]('Node')
		gd.register_class[HUD]('CanvasLayer')
	}
}

pub fn deinit_gd(v voidptr, l gd.GDExtensionInitializationLevel) {
	if l == .initialization_level_scene {
	}
}

@[export: 'gdext_v_init']
fn init_gdext(gpaddr fn (&i8) gd.GDExtensionInterfaceFunctionPtr, clp gd.GDExtensionClassLibraryPtr, mut gdnit gd.GDExtensionInitialization) gd.GDExtensionBool {
	log.set_logger(&gd.GodotLogger{})
	gd.setup_lib(gpaddr, clp)
	gdnit.initialize = init_gd
	gdnit.deinitialize = deinit_gd
	return 1
}
