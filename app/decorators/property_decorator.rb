class PropertyDecorator
  attr_reader :property

  def initialize property
    @property = property
  end

  def save
    @property.charges
  end

  def method_missing method_name, *args, &block
    @property.send method_name, *args, &block
  end

  def respond_to_missing? method_name, include_private = false
    @property.respond_to?(method_name, include_private) || super
  end
end