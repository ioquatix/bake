# frozen_string_literal: true

# Copyright, 2020, by Samuel G. D. Williams. <http://www.codeotaku.com>
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

require 'bake/command/top'
require 'bake/command/call'

RSpec.describe Bake::Command::Call do
	let(:parent) {Bake::Command::Top["--bakefile", __dir__]}
	subject {described_class["test", parent: parent]}
	
	it "can invoke task" do
		expect{subject.call}.to output(/test method called/).to_stdout
	end
	
	context 'with arguments' do
		subject {described_class["test_arguments", "A", "B", parent: parent]}
		
		it "can invoke task" do
			expect{subject.call}.to output(/AB/).to_stdout
		end
	end
	
	context 'with mixed arguments' do
		subject {described_class["test_mixed", "A", "--y", "B", parent: parent]}
		
		it "can invoke task" do
			expect{subject.call}.to output(/AB/).to_stdout
		end
	end
	
	context 'with = options' do
		subject {described_class["test_options", "x=A", "y=B", parent: parent]}
		
		it "can invoke task" do
			expect{subject.call}.to output(/AB/).to_stdout
		end
	end
	
	context 'with -- options' do
		subject {described_class["test_options", "--x", "A", "--y", "B", parent: parent]}
		
		it "can invoke task" do
			expect{subject.call}.to output(/AB/).to_stdout
		end
	end
	
	context 'with test_argument_normalized' do
		subject {described_class[parent: parent]}
		
		it "can accept --foo_bar" do
			expect{subject["test_argument_normalized", "--foo_bar", "A"].call}.to output(/A/).to_stdout
		end
		
		it "can accept --foo-bar" do
			expect{subject["test_argument_normalized", "--foo-bar", "A"].call}.to output(/A/).to_stdout
		end
	end
	
	context 'with value generating task' do
		subject {described_class[parent: parent]}
		
		context 'with json output format' do
			it "can print the value" do
				expect{subject['value', 'output', '--format', 'json'].call}.to output(<<~JSON).to_stdout
				[
				  1,
				  2,
				  3
				]
				JSON
			end
		end
		
		context 'with raw output format' do
			it "can print the value" do
				expect{subject['value', 'output', '--format', 'raw'].call}.to output("1\n2\n3\n").to_stdout
			end
		end
		
		context 'with pp output format' do
			it "can print the value" do
				expect{subject['value', 'output', '--format', 'pp'].call}.to output("[1, 2, 3]\n").to_stdout
			end
		end
		
		context 'with yaml output format' do
			it "can print the value" do
				expect{subject['value', 'output', '--format', 'yaml'].call}.to output(<<~YAML).to_stdout
				---
				- 1
				- 2
				- 3
				YAML
			end
		end
	end
end
