# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2020-2024, by Samuel Williams.

require "bake/base"

describe Bake::Base do
	let(:path) {["foo", "bar"]}
	let(:base) {subject.derive(path)}
	
	it "has a path" do
		expect(base::PATH).to be == path
	end
	
	it "formats nicely" do
		expect(base.inspect).to be == "Bake::Base<foo:bar>"
	end
end
