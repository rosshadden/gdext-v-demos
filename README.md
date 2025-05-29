# gdext-v-demos

Example projects using [gdext-v](https://github.com/rosshadden/gdext-v).

## Usage

```bash
cd dodge_the_creeps/

# build a project
./bin/build.vsh
```

## Details

```bash
# signature
./bin/build.vsh [...options] [path]
```

The `path` is optional, and if not provided, defaults to the current directory.
This lets you run build from other directories, such as the root of this repo: `./bin/build -- dodge_the_creeps/`

These are Godot projects and are meant to be run and edited by Godot.

```bash
# run it
godot

# edit it
godot --editor
```
