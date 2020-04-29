
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