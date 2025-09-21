# Command Line Interface

The `bake` command is broken up into two main functions: `list` and `call`.

<pre>% bake --help
<b>bake [-h/--help] [-b/--bakefile &lt;path&gt;] &lt;command&gt;</b>
	<font color="#638FFF">Execute tasks using Ruby.</font>

	[-h/--help]             Show help.                               
	[-b/--bakefile &lt;path&gt;]  Override the path to the bakefile to use.
	&lt;command&gt;               One of: call, list.                        (default: call)

	<b>call &lt;commands...&gt;</b>
		<font color="#638FFF">Execute one or more commands.</font>

		&lt;commands...&gt;  The commands &amp; arguments to invoke.  (default: [&quot;default&quot;])

	<b>list &lt;pattern&gt;</b>
		&lt;pattern&gt;  The pattern to filter tasks by.
</pre>

## List

The `bake list` command allows you to list all available recipes. By proving a pattern you will only see recipes that have a matching command name.

<pre>$ bake list console
<b>Bake::Loader console-1.8.2</b>

	<b>console:info</b>
		<font color="#638FFF">Increase the verbosity of the logger to info.</font>

	<b>console:debug</b>
		<font color="#638FFF">Increase the verbosity of the logger to debug.</font>
</pre>

The listing documents positional and optional arguments. The documentation is generated from the comments in the bakefiles.

## Call

The `bake call` (the default, so `call` can be omitted) allows you to execute one or more recipes. You must provide the name of the command, followed by any arguments.

<pre>$ bake async:http:head https://www.codeotaku.com/index
<font color="#638FFF"><b>                HEAD</b></font>: https://www.codeotaku.com/index
<font color="#00AA00"><b>             version</b></font>: h2
<font color="#00AA00"><b>              status</b></font>: 200
<font color="#00AA00"><b>                body</b></font>: body with length <b>7879B</b>
<b>        content-type</b>: &quot;text/html; charset=utf-8&quot;
<b>       cache-control</b>: &quot;public, max-age=3600&quot;
<b>             expires</b>: &quot;Mon, 04 May 2020 13:23:47 GMT&quot;
<b>              server</b>: &quot;falcon/0.36.4&quot;
<b>                date</b>: &quot;Mon, 04 May 2020 12:23:47 GMT&quot;
<b>                vary</b>: &quot;accept-encoding&quot;
</pre>

You can specify multiple commands and they will be executed sequentially.
