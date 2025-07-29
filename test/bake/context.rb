# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2020-2025, by Samuel Williams.

require "bake/context"

describe Bake::Context do
	let(:bakefile) {File.expand_path(".test-project/bake.rb", __dir__)}
	let(:context) {subject.load(bakefile)}
	
	it "can invoke root task" do
		recipe = context.lookup("doot")
		
		expect(recipe).to receive(:call)
		expect(recipe.instance).to receive(:doot)
		
		context.call("doot")
	end
	
	with "#invoke" do
		let(:instance) {context.lookup("invoke:task1").instance}
		
		it "can invoke another task" do
			expect(instance).to receive(:task1).with("argument", option: "option")
			expect(instance).to receive(:task2)
			
			context.call("invoke:task2")
		end
		
		it "can invoke task with required argument" do
			context.call("invoke:task3", "argument")
		end
	end
	
	with "#lookup" do
		it "can lookup method on parent instance" do
			parent = context.lookup("parent")
			
			expect(parent).not.to be_nil
			expect(parent.instance).to be(:respond_to?, :parent)
		end
		
		it "can lookup method on child instance" do
			child = context.lookup("parent:child")
			
			expect(child).not.to be_nil
			expect(child.instance).to be(:respond_to?, :child)
		end
		
		it "can lookup method on sibling instance" do
			parent = context.lookup("parent:sibling")
			
			expect(parent).not.to be_nil
			expect(parent.instance).to be(:respond_to?, :parent)
		end
	end
end
