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

Please see the [project documentation](https://ioquatix.github.io/bake/).

## Contributing

We welcome contributions to this project.

1.  Fork it.
2.  Create your feature branch (`git checkout -b my-new-feature`).
3.  Commit your changes (`git commit -am 'Add some feature'`).
4.  Push to the branch (`git push origin my-new-feature`).
5.  Create new Pull Request.

### Developer Certificate of Origin

This project uses the [Developer Certificate of Origin](https://developercertificate.org/). All contributors to this project must agree to this document to have their contributions accepted.

### Contributor Covenant

This project is governed by the [Contributor Covenant](https://www.contributor-covenant.org/). All contributors and participants agree to abide by its terms.

## See Also

  - [Bake::Gem](https://github.com/ioquatix/bake-gem) — Release and install gems using `bake`.
  - [Bake::Modernize](https://github.com/ioquatix/bake-modernize) — Modernize gems consistently using `bake`.
  - [Console](https://github.com/socketry/console) — A logging framework which integrates with `bake`.
  - [Variant](https://github.com/socketry/variant) — A framework for selecting different environments, including `bake` tasks.
  - [Utopia](https://github.com/socketry/utopia) — A website framework which uses `bake` for maintenance tasks.
