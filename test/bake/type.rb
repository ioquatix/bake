# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2020-2024, by Samuel Williams.

require "bake/type"
require "bake/context"

describe Bake::Type do
	it "can use | operator" do
		type = Bake::Type::Array(Bake::Type::Integer) | Bake::Type::String
	end
	
	with "test project" do
		let(:bakefile) {File.expand_path(".test-project/bake.rb", __dir__)}
		let(:context) {Bake::Context.load(bakefile)}
		
		it "should parse integer" do
			result = context.call("types:square", "5")
			
			expect(result).to be_a(Integer)
			expect(result).to be == 25
		end
		
		it "should parse an array of integers" do
			result = context.call("types:sum", "1,2,3,4,5")
			
			expect(result).to be_a(Integer)
			expect(result).to be == 15
		end
		
		it "should parse a symbol and a hash" do
			result = context.call("types:index", "foo", "foo:10,bar:20")
			
			expect(result).to be_a(Integer)
			expect(result).to be == 10
		end
		
		it "should parse a JSON string" do
			result = context.call("types:inspect", '{"x": 10}')
			
			expect(result).to be_a(Hash)
			expect(result).to be == {"x" => 10}
		end
		
		it "should parse a URI string" do
			result = context.call("types:hostname", "https://www.google.com")
			
			expect(result).to be_a(String)
			expect(result).to be == "www.google.com"
		end
	end
end
