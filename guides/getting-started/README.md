# Getting Started

This guide gives a general overview of `bake` and how to use it.

## Installation

Add the gem to your project:

~~~ bash
$ bundle add bake
~~~

## Core Concepts

`bake` has several core concepts:

- A `bake` executable used for invoking one or more tasks.
- A {ruby Bake::Context} instance which is bound to a project or gem and exposes a hierarchy of runnable tasks.
- A {ruby Bake::Loaders} instance which is used for on-demand loading of bake files from the current project and all available gems.

## Executing Tasks

The `bake` executable can be used to execute tasks in a `bake.rb` file in the same directory.

``` ruby
# bake.rb

def add(x, y)
	puts Integer(x) + Integer(y)
end
```

You can execute this task from the command line:

``` shell
% bake add 10 20
30
```

### Executing Multiple Tasks

The `bake` executable can execute multiple tasks in one invocation and even pass the output of one task into a subsequent task.

``` ruby
# bake.rb

attr_accessor :value
```

You can set and print the value:

``` shell
% bake value= 10 value output
```

This is essentially broken down into three operations: `value = 10`, `value` & `output`. The `value` method returns the current value and the `output` task prints the result of the previous task.

## Optional Arguments

You can provide optional arguments:

``` ruby
# bake.rb

def add(x: 10, y: 20)
	puts Integer(x) + Integer(y)
end
```

You can execute this task from the command line:

``` shell
% bake add --x 10 --y 20
30
```

Or alternatively:

``` shell
% bake add x=10 y=20
30
```

### Using Types

You can annotate your task with a type signature and `bake` will coerce your arguments to these types:

``` ruby
# bake.rb

# @parameter x [Integer]
# @parameter y [Integer]
def add(x, y)
	puts x + y
end
```

You can execute this task from the command line:

``` shell
% bake add 10 20
30
```

The values are automatically coerced to `Integer`.

### Extending With Documentation

You can add documentation to your tasks and parameters (using Markdown formatting).

``` ruby
# bake.rb

# Add the x and y coordinate together and print the result.
# @parameter x [Integer] The x offset.
# @parameter y [Integer] The y offset.
def add(x, y)
	puts x + y
end
```

You can see this documentation in the task listing:

``` shell
% bake list add
Bake::Context getting-started

	add x y
		Add the x and y coordinate together and print the result.
		x [Integer] The x offset.
		y [Integer] The y offset.
```

### Private Methods

If you want to add helper methods which don't show up as tasks, define them as `protected` or `private`.

``` ruby
# bake.rb

# Add the x and y coordinate together and print the result.
# @parameter x [Integer] The x offset.
# @parameter y [Integer] The y offset.
def add(x, y)
	puts x + y
end

private

def puts(*arguments)
	$stdout.puts arguments.inspect
end
```
