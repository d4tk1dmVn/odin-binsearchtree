class BinaryNode
  include Comparable

  attr_accessor :value, :left, :right, :parent

  def initialize(value)
    @value = value
    @left = nil
    @right = nil
    @parent = nil
  end

  def <=>(other)
    @value <=> other.value
  end

  def sire_child(other)
    other < self ? @left = other : @right = other
    other.parent = self
  end

  def ostracize
    raise(StandardError, "Can't ostracize parentless node") unless parent

    parent > self ? parent.left = nil : parent.right = nil
  end

  def can_sire?(value)
    (@left.nil? && @value > value) || (@right.nil? && @value < value)
  end

  def leaf?
    !(@left || @right)
  end

  def two_children?
    @left && @right
  end

  def any_children?
    @left || @right
  end
end
