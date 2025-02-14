# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2023-2024, by Samuel Williams.

require "bake/type/output"

describe Bake::Type::Output do
	let(:value) {subject.parse(text)}
	
	with text: "-" do
		it "should be stdout" do
			expect(value).to be_a(IO)
			expect(value).to be == $stdout
		end
	end
	
	with text: File.expand_path("output.txt", __dir__) do
		it "should open file" do
			expect(value).to be_a(IO)
		end
	end
end
