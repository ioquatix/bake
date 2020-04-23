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

require 'bake/types'

RSpec.describe Bake::Types do
	subject {described_class.parse(description)}
	
	context "Array(Any)" do
		it {is_expected.to be_kind_of(Bake::Types::Array)}
	end
	
	it "can use | operator" do
		type = Bake::Types::Array(Bake::Types::Integer) | Bake::Types::String
	end
end

require 'bake/context'
require 'bake/loaders'

RSpec.describe Bake::Context do
	let(:bakefile) {File.expand_path("test-project/bake.rb", __dir__)}
	subject {described_class.load(bakefile)}
	
	it "should parse integer" do
		result = subject.call('types:square', '5')
		
		expect(result).to be_kind_of(Integer)
		expect(result).to be == 25
	end
	
	it "should parse an array of integers" do
		result = subject.call('types:sum', '1,2,3,4,5')
		
		expect(result).to be_kind_of(Integer)
		expect(result).to be == 15
	end
	
	it "should parse a symbol and a hash" do
		result = subject.call('types:index', 'foo', 'foo:10,bar:20')
		
		expect(result).to be_kind_of(Integer)
		expect(result).to be == 10
	end
	
	it "should parse a JSON string" do
		result = subject.call('types:inspect', '{"x": 10}')
		
		expect(result).to be_kind_of(Hash)
		expect(result).to be == {"x" => 10}
	end
	
	it "should parse a URI string" do
		result = subject.call('types:hostname', 'https://www.google.com')
		
		expect(result).to be_kind_of(String)
		expect(result).to be == "www.google.com"
	end
end
