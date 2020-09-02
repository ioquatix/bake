# Bake

Bake is a task execution tool, inspired by Rake, but codifying many of the use cases which are typically implemented in an ad-hoc manner.

[![Development Status](https://github.com/ioquatix/bake/workflows/Development/badge.svg)](https://github.com/ioquatix/bake/actions?workflow=Development)

## Features

Rake is an awesome tool and loved by the community. So, why reinvent it? Bake provides the following features that Rake does not:

  - On demand loading of files following a standard convention. This avoid loading all your rake tasks just to execute a single command.
  - Better argument handling including support for positional and optional arguments.
  - Focused on task execution not dependency resolution. Implementation is simpler and a bit more predictable.
  - Canonical structure for integration with gems.

That being said, Rake and Bake can exist side by side in the same project.

## Usage

Please see the [project documentation](https://ioquatix.github.io/bake/).

## Contributing

We welcome contributions to this project.

1.  Fork it.
2.  Create your feature branch (`git checkout -b my-new-feature`).
3.  Commit your changes (`git commit -am 'Add some feature'`).
4.  Push to the branch (`git push origin my-new-feature`).
5.  Create new Pull Request.

## See Also

  - [Bake::Bundler](https://github.com/ioquatix/bake-bundler) — Release and install gems using `bake`.
  - [Bake::Modernize](https://github.com/ioquatix/bake-modernize) — Modernize gems consistently using `bake`.
  - [Console](https://github.com/socketry/console) — A logging framework which integrates with `bake`.
  - [Variant](https://github.com/socketry/variant) — A framework for selecting different environments, including `bake` tasks.
  - [Utopia](https://github.com/socketry/utopia) — A website framework which uses `bake` for maintenance tasks.

## License

Released under the MIT license.

Copyright, 2020, by [Samuel G. D. Williams](http://www.codeotaku.com).

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
