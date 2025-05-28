#!/usr/bin/env -S v

import cli
import os
import time

fn run(cmd string) {
	execute(cmd)
}

fn build(cmd cli.Command) ! {
	start := time.now()
	project := cmd.args[0]
	compiler := cmd.flags.get_string('compiler')!
	out := cmd.flags.get_string('out')!

	println('Building project... ${project}')

	mut options := [
		'-shared',
		'-enable-globals',
		// '-d no_backtrace',
		'-o ${out}',
	]

	if compiler != 'tcc' {
		options << '-cc ${compiler}'
	}
	if cmd.flags.get_bool('debug')! {
		options << '-g'
	}

	run('${@VEXE} ${options.join(' ')} ${project}')

	// remove exec bit if using tcc
	if compiler == 'tcc' {
		run('patchelf --clear-execstack ${out}')
	}

	end := time.now()
	println('Finished in ${end - start}')
}

fn main() {
	mut app := cli.Command{
		name:          'build'
		description:   'gdext-v built script'
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
		execute:       build
	}

	app.setup()
	app.parse(os.args_after('--'))
}
