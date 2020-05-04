# Project Integration

This guide explains how to add `bake` to a Ruby project.

## Bakefile

At the top level of your project, you can create a `bake.rb` file, which contains top level tasks which are private to your project.

~~~ ruby
def cake
	ingredients = call 'supermarket:shop', 'flour,sugar,cocoa'
	lookup('mixer:add').call(ingredients)
end
~~~

This file is project specific and is the only file which can expose top level tasks (i.e. without a defined namespace). When used in a gem, these tasks are not exposed to other gems/projects.

## Recipes

Alongside the `bake.rb`, there is a `bake/` directory which contains files like `supermarket.rb`. These files contain recipes, e.g.:

~~~ ruby
# @param ingredients [Array(Any)] the ingredients to purchase.
def shop(ingredients)
	supermarket = Supermarket.best
	
	return supermarket.purchase(ingredients)
end
~~~

These methods are automatically scoped according to the file name, e.g. `bake/supermarket.rb` will define `supermarket:shop`.


## Arguments

Arguments work as normal. Documented types are used to parse strings from the command line. Both positional and optional parameters are supported.

### Positional Parameters

Positional parameters are non-keyword parameters which may have a default value. However, because of the limits of the command line, all positional arguments must be specified.

~~~ ruby
# @param x [Integer]
# @param y [Integer]
def add(x, y)
	puts x + y
end
~~~

Which is invoked by `bake add 1 2`.

### Optional Parameters

Optional parameters are keyword parameters which may have a default value. The parameter is set on the command line using the name of the parameter followed by an equals sign, followed by the value.

~~~ ruby
# @param x [Integer]
# @param y [Integer]
def add(x:, y: 2)
	puts x + y
end
~~~

Which is invoked by `bake add x=1`. Because `y` is not specified, it will default to `2` as per the method definition.
