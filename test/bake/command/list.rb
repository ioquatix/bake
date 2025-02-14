# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2020-2024, by Samuel Williams.

require "bake/command/top"
require "bake/command/list"

describe Bake::Command::List do
	let(:root) {File.expand_path(".test-project", __dir__)}
	let(:buffer) {StringIO.new}
	let(:parent) {Bake::Command::Top["--bakefile", root, output: buffer]}
	let(:command) {subject[parent: parent]}
	
	it "can list tasks" do
		inform(command.call)
		expect(buffer.string).to be =~ /A test method./
	end
	
	with "pattern" do
		let(:command) {subject["a_very_unique_method", parent: parent]}
		
		it "lists only matching tasks" do
			inform(command.call)
			expect(buffer.string).to be =~ /a_very_unique_method/
		end
	end
end
