# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2020-2022, by Samuel Williams.

require 'bake/command/top'
require 'bake/command/call'

describe Bake::Command::Call do
	let(:root) {File.expand_path(".test-project", __dir__)}
	let(:parent) {Bake::Command::Top["--bakefile", root]}
	let(:command) {subject["test_called", parent: parent]}
	
	it "can invoke task" do
		expect(command.call).to be == true
	end
	
	with 'arguments' do
		let(:command) {subject["test_arguments", "A", "B", parent: parent]}
		
		it "can invoke task" do
			expect(command.call).to be =~ /AB/
		end
	end
	
	with 'mixed arguments' do
		let(:command) {subject["test_mixed", "A", "--y", "B", parent: parent]}
		
		it "can invoke task" do
			expect(command.call).to be =~ /AB/
		end
	end
	
	with '= options' do
		let(:command) {subject["test_options", "x=A", "y=B", parent: parent]}
		
		it "can invoke task" do
			expect(command.call).to be =~ /AB/
		end
	end
	
	with '-- options' do
		let(:command) {subject["test_options", "--x", "A", "--y", "B", parent: parent]}
		
		it "can invoke task" do
			expect(command.call).to be =~ /AB/
		end
	end
	
	with 'test_argument_normalized' do
		let(:command) {subject[parent: parent]}
		
		it "can accept --foo_bar" do
			expect(command["test_argument_normalized", "--foo_bar", "A"].call).to be =~ /A/
		end
		
		it "can accept --foo-bar" do
			expect(command["test_argument_normalized", "--foo-bar", "A"].call).to be =~ /A/
		end
	end
	
	with 'value generating task' do
		let(:command) {subject[parent: parent]}
		let(:buffer) {StringIO.new}
		
		with 'json output format' do
			it "can print the value" do
				command['value', 'output', '--format', 'json', '--file', buffer].call
				expect(buffer.string).to be == <<~JSON
				[
				  1,
				  2,
				  3
				]
				JSON
			end
		end
		
		with 'raw output format' do
			it "can print the value" do
				command['value', 'output', '--format', 'raw', '--file', buffer].call
				expect(buffer.string).to be == "1\n2\n3\n"
			end
		end
		
		with 'pp output format' do
			it "can print the value" do
				command['value', 'output', '--format', 'pp', '--file', buffer].call
				expect(buffer.string).to be == "[1, 2, 3]\n"
			end
		end
		
		with 'yaml output format' do
			it "can print the value" do
				command['value', 'output', '--format', 'yaml', '--file', buffer].call
				expect(buffer.string).to be == <<~YAML
				---
				- 1
				- 2
				- 3
				YAML
			end
		end
	end
end
