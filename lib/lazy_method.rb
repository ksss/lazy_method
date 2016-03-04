class LazyMethod
  require "lazy_method/version"

  attr_reader :receiver
  def initialize(receiver)
    @receiver = receiver
    @lazy_call_method = nil
  end

  METHOD_METHODS = %i(
    source_location
    parameters
    arity
    name
    owner
    to_proc
    unbind
  )
  if "2.2.0" <= RUBY_VERSION
    METHOD_METHODS << :super_method
  end
  METHOD_METHODS.each do |m|
    define_method(m) do
      @lazy_call_method = m
      self
    end
  end

  def to_s
    "#<LazyMethod #{@receiver}#{@lazy_call_method ? "(#{@lazy_call_method})" : ''}>"
  end
  alias inspect to_s

  private

  def respond_to_missing?(name, _include_private)
    case name
    when :to_ary
      false
    else
      true
    end
  end

  def method_missing(name, *)
    return unless respond_to_missing?(name, false)
    m = @receiver.__method__(name)
    if @lazy_call_method
      m.__send__ @lazy_call_method
    else
      m
    end
  end

  module API
    def method(name = nil)
      if name
        super
      else
        LazyMethod.new(self)
      end
    end
  end
  Kernel.__send__ :alias_method, :__method__, :method
  Object.prepend API
end
