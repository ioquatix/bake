# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2020-2021, by Samuel Williams.

require 'bake'

describe Bake do
	it "has a version number" do
		expect(Bake::VERSION).to be =~ /\d+\.\d+\.\d+/
	end
end
