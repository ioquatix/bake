# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2026, by Samuel Williams.

require "bake/base"

class TestArguments < Bake::Base
	def positional(url)
		url
	end
	
	def mixed(url, option: nil)
		[url, option]
	end
end

describe Bake::Arguments do
	let(:instance) {TestArguments.new}
	
	it "prefers positional arguments before key/value arguments" do
		recipe = instance.recipe_for(:positional)
		arguments, options = recipe.prepare(["https://foo?x=y"])
		
		expect(arguments).to be == ["https://foo?x=y"]
		expect(options).to be == {}
	end
	
	it "extracts key/value arguments after positional arguments" do
		recipe = instance.recipe_for(:mixed)
		arguments, options = recipe.prepare(["https://foo?x=y", "option=value"])
		
		expect(arguments).to be == ["https://foo?x=y"]
		expect(options).to be == {option: "value"}
	end
end
