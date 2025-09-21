# Input and Output

`bake` has built in tasks for reading input and writing output in different formats. While this can be useful for general processing, there are some limitations, notably that rich object representations like `json` and `yaml` often don't support stream processing.

## Input

The `input` task reads from `stdin` or a specified `--file` path. It handles a number of different `--format` arguments including `json` and `yaml`.

``` shell
> bake input --file data.json --format json output
[{"name"=>"Alice", "age"=>30}, {"name"=>"Bob", "age"=>40}]
```

### Text

Instead of using a file, you can parse a string argument.

``` shell
> bin/bake input:parse "[1,2,3]" output
[1, 2, 3]
```

## Output

The `output` task takes the return value from the previous command and outputs it to `stdout` or the specified `--file` path. It also handles a number of differnt `--format` arguments including `json`, `yaml`, `raw` and the default `pp`.

``` shell
> bin/bake input --file data.json output --format yaml
---
- name: Alice
  age: 30
- name: Bob
  age: 40
```
