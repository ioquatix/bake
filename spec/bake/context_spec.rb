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

require 'bake/context'
require 'bake/loaders'

RSpec.describe Bake::Context do
	let(:bakefile) {File.expand_path("test-project/bake.rb", __dir__)}
	subject {described_class.load(bakefile)}
	
	it 'can invoke root task' do
		expect(subject.lookup('doot')).to receive(:call).and_call_original
		
		subject.call('doot')
	end
	
	describe '#invoke' do
		let(:instance) {subject.lookup('invoke:task1').instance}
		
		it "can invoke another task" do
			expect(instance).to receive(:task1).with("argument", option: "option").and_call_original
			expect(instance).to receive(:task2).and_call_original
			
			subject.call('invoke:task2')
		end
		
		it "can invoke task with required argument" do
			subject.call('invoke:task3', 'argument')
		end
	end
	
	describe '#lookup' do
		it "can lookup method on parent instance" do
			parent = subject.lookup('parent')
			
			expect(parent).to_not be_nil
			expect(parent.instance).to be_respond_to(:parent)
		end
		
		it "can lookup method on child instance" do
			child = subject.lookup('parent:child')
			
			expect(child).to_not be_nil
			expect(child.instance).to be_respond_to(:child)
		end
		
		it "can lookup method on sibling instance" do
			parent = subject.lookup('parent:sibling')
			
			expect(parent).to_not be_nil
			expect(parent.instance).to be_respond_to(:parent)
		end
	end
end
