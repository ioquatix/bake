# ![Bake](logo.svg)

Bake is a task execution tool, inspired by Rake, but codifying many of the use cases which are typically implemented in an ad-hoc manner.

[![Development Status](https://github.com/ioquatix/bake/workflows/Test/badge.svg)](https://github.com/ioquatix/bake/actions?workflow=Test)

## Features

Rake is an awesome tool and loved by the community. So, why reinvent it? Bake provides the following features that Rake does not:

  - On demand loading of files following a standard convention. This avoid loading all your rake tasks just to execute a single command.
  - Better argument handling including support for positional and optional arguments.
  - Focused on task execution not dependency resolution. Implementation is simpler and a bit more predictable.
  - Canonical structure for integration with gems.

That being said, Rake and Bake can exist side by side in the same project.

## Usage

Please see the [project documentation](https://ioquatix.github.io/bake/) for more details.

  - [Getting Started](https://ioquatix.github.io/bake/guides/getting-started/index) - This guide gives a general overview of `bake` and how to use it.

  - [Command Line Interface](https://ioquatix.github.io/bake/guides/command-line-interface/index) - The `bake` command is broken up into two main functions: `list` and `call`.

  - [Project Integration](https://ioquatix.github.io/bake/guides/project-integration/index) - This guide explains how to add `bake` to a Ruby project.

  - [Gem Integration](https://ioquatix.github.io/bake/guides/gem-integration/index) - This guide explains how to add `bake` to a Ruby gem and export standardised tasks for use by other gems and projects.

  - [Input and Output](https://ioquatix.github.io/bake/guides/input-and-output/index) - `bake` has built in tasks for reading input and writing output in different formats. While this can be useful for general processing, there are some limitations, notably that rich object representations like `json` and `yaml` often don't support stream processing.

## Releases

Please see the [project releases](https://ioquatix.github.io/bake/releases/index) for all releases.

### v0.24.1

  - Add agent context.

### v0.24.0

  - If the final result of a recipe is not an `output?`, it will now be passed to the default output recipe.

### v0.23.0

  - Add support for `ndjson`.
  - General improvements to input and output handling.
  - Removed support for `pp` output - use `raw` if required.

## Contributing

We welcome contributions to this project.

1.  Fork it.
2.  Create your feature branch (`git checkout -b my-new-feature`).
3.  Commit your changes (`git commit -am 'Add some feature'`).
4.  Push to the branch (`git push origin my-new-feature`).
5.  Create new Pull Request.

### Developer Certificate of Origin

In order to protect users of this project, we require all contributors to comply with the [Developer Certificate of Origin](https://developercertificate.org/). This ensures that all contributions are properly licensed and attributed.

### Community Guidelines

This project is best served by a collaborative and respectful environment. Treat each other professionally, respect differing viewpoints, and engage constructively. Harassment, discrimination, or harmful behavior is not tolerated. Communicate clearly, listen actively, and support one another. If any issues arise, please inform the project maintainers.

## See Also

  - [Bake::Gem](https://github.com/ioquatix/bake-gem) — Release and install gems using `bake`.
  - [Bake::Modernize](https://github.com/ioquatix/bake-modernize) — Modernize gems consistently using `bake`.
  - [Console](https://github.com/socketry/console) — A logging framework which integrates with `bake`.
  - [Variant](https://github.com/socketry/variant) — A framework for selecting different environments, including `bake` tasks.
  - [Utopia](https://github.com/socketry/utopia) — A website framework which uses `bake` for maintenance tasks.
