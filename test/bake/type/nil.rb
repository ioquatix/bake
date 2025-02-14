# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2023-2024, by Samuel Williams.

require "bake/type/nil"

describe Bake::Type::Nil do
	let(:value) {subject.parse(text)}
	
	with text: "nil" do
		it "should be nil" do
			expect(value).to be_a(NilClass)
			expect(value).to be == nil
		end
	end
	
	with text: "null" do
		it "should be nil" do
			expect(value).to be_a(NilClass)
			expect(value).to be == nil
		end
	end
end
