#!/usr/bin/env -S v

import cli
import time

@[heap]
struct App {
mut:
	ctx struct {
	mut:
		start time.Time
		project string
		compiler string
		out string
		debug bool
	}
}

fn (mut app App) exec(cmd string) ! {
	if app.ctx.debug {
		println('Running command: ${cmd}')
	}
	execute(cmd)
}

fn (mut app App) setup(cmd cli.Command) ! {
	app.ctx.start = time.now()
	app.ctx.project = cmd.args[0]
	app.ctx.compiler = cmd.flags.get_string('compiler')!
	app.ctx.out = join_path(app.ctx.project, cmd.flags.get_string('out')!)
	app.ctx.debug = cmd.flags.get_bool('debug')!
}

fn (mut app App) run() ! {
	println('Building project: ${app.ctx.project}')

	mut options := [
		'-shared',
		'-enable-globals',
		'-o ${app.ctx.out}',
	]

	if app.ctx.compiler == 'tcc' {
		options << '-d no_backtrace'
	} else {
		options << '-cc ${app.ctx.compiler}'
	}
	if app.ctx.debug {
		options << '-g'
	}

	app.exec('${@VEXE} ${options.join(' ')} ${app.ctx.project}')!

	// remove exec bit if using tcc
	if app.ctx.compiler == 'tcc' {
		app.exec('patchelf --clear-execstack ${app.ctx.out}')!
	}

	println('Finished in ${time.now() - app.ctx.start}')
}

fn main() {
	mut cmd := cli.Command{
		name:          'build'
		description:   'gdext-v built script'
		execute: fn (cmd cli.Command) ! {
			mut app := App{}
			app.setup(cmd)!
			app.run()!
		}
		required_args: 1
		args:          ['project']
		flags:         [
			cli.Flag{
				flag:        .bool
				name:        'debug'
				abbrev:      'd'
				description: 'Enable debug mode'
			},
			cli.Flag{
				flag:          .string
				name:          'compiler'
				abbrev:        'c'
				description:   'C compiler'
				default_value: ['tcc']
			},
			cli.Flag{
				flag:          .string
				name:          'out'
				abbrev:        'o'
				description:   'Output file'
				default_value: ['lib/libvlang.so']
			},
		]
	}

	cmd.setup()
	cmd.parse(args_after('--'))
}
