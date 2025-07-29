# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2025, by Samuel Williams.

require "bake/recipe"

class TestObject < Bake::Base
	def test(*arguments, **options, &block)
		[arguments, options, block]
	end
end

describe Bake::Recipe do
	let(:instance) {TestObject.new}
	let(:name) {"test"}
	let(:recipe) {subject.new(instance, name)}
	
	with "#call" do
		it "can call method with no arguments" do
			result = recipe.call
			
			expect(result).to be == [[], {}, nil]
		end
		
		it "can call method with arguments" do
			result = recipe.call(1, 2, 3)
			
			expect(result).to be == [[1, 2, 3], {}, nil]
		end
		
		it "can call method with options" do
			result = recipe.call(option: 1)
			
			expect(result).to be == [[], {option: 1}, nil]
		end
		
		it "can call method with block" do
			block = ->{}
			
			result = recipe.call(&block)
			
			expect(result).to be == [[], {}, block]
		end
	end
	
	with "#output?" do
		it "returns false by default" do
			expect(recipe.output?).to be == false
		end
		
		it "returns true if instance has output?" do
			expect(instance).to receive(:output?).and_return(true)
			
			expect(recipe.output?).to be == true
		end
	end
end
