module Bake
	module Loader
		class InlineLoader
			def initialize
				@wrappers = Hash.new do |hash, key|
					hash[key] = []
				end
			end
			
			class Wrapper
				def initialize(wrappers, path)
					@wrappers = wrappers
					@path = path
				end
				
				def before(name = @path.last, &block)
					wrapper = Module.new
					wrapper.define_method(name) do |*arguments, **options|
						instance_exec(&block)
						super(*arguments, **options)
					end
					
					@wrappers[@path] << wrapper
				end
				
				def after(name = @path.last, &block)
					wrapper = Module.new
					wrapper.define_method(name) do |*arguments, **options|
						super(*arguments, **options)
						instance_exec(&block)
					end
					
					@wrappers[@path] << wrapper
				end
			end
			
			def wrap(*path, &block)
				Wrapper.new(@wrappers, path).instance_exec(&block)
			end
			
			def each(&block)
			end
			
			def scopes_for(path, &block)
				@wrappers[path].each(&block)
			end
		end
	end
end
