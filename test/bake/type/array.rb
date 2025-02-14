# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2023, by Samuel Williams.

require "bake/type/array"
require "bake/type"

describe Bake::Type::Array do
	let(:type) {Bake::Type.parse(typename)}
	
	with typename: "Array(Integer)" do
		it "can parse an array of integers" do
			expect(type.parse("1,2,3,4,5")).to be == [1, 2, 3, 4, 5]
		end
	end
end
