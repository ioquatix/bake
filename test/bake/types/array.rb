# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2023, by Samuel Williams.

require 'bake/types/array'
require 'bake/types'

describe Bake::Types::Array do
	let(:type) {Bake::Types.parse(typename)}
	
	with typename: "Array(Integer)" do
		it "can parse an array of integers" do
			expect(type.parse("1,2,3,4,5")).to be == [1, 2, 3, 4, 5]
		end
	end
end
