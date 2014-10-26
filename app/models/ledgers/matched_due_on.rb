MatchedDueOn = Struct.new(:spot, :show) do
  def <=> other
    return nil unless other.is_a?(self.class)
    [spot, show] <=> [other.spot, other.show]
  end
end
