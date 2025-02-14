# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2023-2024, by Samuel Williams.

require "bake/types/boolean"

describe Bake::Types::Boolean do
	let(:value) {subject.parse(text)}
	
	with text: "true" do
		it "should be true" do
			expect(value).to be_a(TrueClass)
			expect(value).to be == true
		end
	end
	
	with text: "false" do
		it "should be false" do
			expect(value).to be_a(FalseClass)
			expect(value).to be == false
		end
	end
end
