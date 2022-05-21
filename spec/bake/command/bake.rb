# frozen_string_literal: true

def initialize(*)
	super
	@called = false
end

attr :called

# A test method.
#
# A second paragraph.
#
#
def test
	@called = true
	puts "test method called"
end

def a_very_unique_method
end

def test_arguments(x, y)
	puts x+y
end

def test_options(x:, y:)
	puts x+y
end

def test_argument_normalized(foo_bar:)
	puts foo_bar
end

def value
	[1, 2, 3]
end
