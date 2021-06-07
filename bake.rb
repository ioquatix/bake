# frozen_string_literal: true

# @parameter paths [Array(String)] The globbed paths.
def print_glob(paths:)
	puts paths.inspect
end

# You can invoke this command in one of serveral ways:
# bake multiple --tags tag1 tag2 tag3 --name "my name"
# bake multiple --name "my name" --tags tag1 tag2 tag3 \; print_glob --paths *
# Use "\;" to terminate the list of items for a specific argument.
#
# @parameter tags [Array(String)]
# @parameter name [String]
def multiple(tags: [], name:)
	pp [name, tags]
end
