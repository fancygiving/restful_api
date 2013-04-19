class Mapper

  attr_reader :target

  def initialize(target)
    @target = target
  end

  def map(data)
    target.new(data)
  end
end