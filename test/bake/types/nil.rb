# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2020-2021, by Samuel Williams.

require 'bake/types/nil'

describe Bake::Types::Nil do
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
