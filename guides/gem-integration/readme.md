# Gem Integration

This guide explains how to add `bake` to a Ruby gem and export standardised tasks for use by other gems and projects.

## Exporting Tasks

Adding a `bake/` directory to your gem will allow other gems and projects to consume those recipes. In order to prevent collisions, you *should* prefix your commands with the name of the gem, e.g. in `mygem/bake/mygem.rb`:

~~~ ruby
def setup
	# ...
end
~~~

Then, in a different project which depends on `mygem`, you can run tasks from `mygem` by invoking them using `bake`:

~~~ bash
$ bake mygem:setup
~~~

## Examples

There are many gems which export tasks in this way. Here are some notable examples:

### Variant

The [variant gem](https://github.com/socketry/variant) exposes bake tasks for setting the environment e.g. `development`, `testing`, or `production`.

<pre class="terminal">$ bake list variant
<b>Bake::Loader variant-0.1.1</b>

	<b>variant:production</b> <font color="#00AA00">**overrides</font>
		<font color="#638FFF">Select the production variant.</font>
		<font color="#00AA00">overrides</font> [Hash] <font color="#638FFF">any specific variant overrides.</font>

	<b>variant:staging</b> <font color="#00AA00">**overrides</font>
		<font color="#638FFF">Select the staging variant.</font>
		<font color="#00AA00">overrides</font> [Hash] <font color="#638FFF">any specific variant overrides.</font>

	<b>variant:development</b> <font color="#00AA00">**overrides</font>
		<font color="#638FFF">Select the development variant.</font>
		<font color="#00AA00">overrides</font> [Hash] <font color="#638FFF">any specific variant overrides.</font>

	<b>variant:testing</b> <font color="#00AA00">**overrides</font>
		<font color="#638FFF">Select the testing variant.</font>
		<font color="#00AA00">overrides</font> [Hash] <font color="#638FFF">any specific variant overrides.</font>

	<b>variant:force</b> <font color="#AA0000">name</font> <font color="#00AA00">**overrides</font>
		<font color="#638FFF">Force a specific variant.</font>
		<font color="#00AA00">name</font> [Symbol] <font color="#638FFF">the default variant.</font>
		<font color="#00AA00">overrides</font> [Hash] <font color="#638FFF">any specific variant overrides.</font>

	<b>variant:show</b>
		<font color="#638FFF">Show variant-related environment variables.</font>
</pre>

### Console

The [console gem](https://github.com/socketry/console) exposes bake tasks to change the log level.

<pre class="terminal">$ bake list console
<b>Bake::Loader console-1.8.2</b>

	<b>console:info</b>
		<font color="#638FFF">Increase the verbosity of the logger to info.</font>

	<b>console:debug</b>
		<font color="#638FFF">Increase the verbosity of the logger to debug.</font>
</pre>
