# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2023-2025, by Samuel Williams.

require "bake/type/input"

describe Bake::Type::Input do
	let(:value) {subject.parse(text)}
	
	with text: "-" do
		it "should be stdin" do
			expect(value).to be_a(IO)
			expect(value).to be == $stdin
		end
	end
	
	with text: File.expand_path("input.txt", __dir__) do
		it "should open file" do
			expect(value).to be_a(IO)
			expect(value.gets).to be == "Hello World!\n"
		end
	end
end
