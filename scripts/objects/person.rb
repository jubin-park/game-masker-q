class Person
  class << self
    alias_method :abstract_new, :new
    def new(*args)
      raise "Abstract class #{self} cannot instantiate" if self == Person
      abstract_new(*args)
    end
  end

  ENUM_DIRECTION = [
    DIRECTION_LEFT = 0,
    DIRECTION_RIGHT = 1
  ]

  attr_reader :x
  attr_accessor :dx

  def initialize
    @x = WINDOW_WIDTH.to_f
    @dx = 2.0
    @direction = DIRECTION_LEFT
    @diagnosing = true
    return
  end

  def move_left
    @direction = DIRECTION_LEFT
    return
  end

  def move_right
    @direction = DIRECTION_RIGHT
    return
  end

  def finalize_diagnosis
    @diagnosing = false
    return
  end

  def diagnosing?
    return @diagnosing ? true : false
  end

  def disposed?
    return @x < -240.0 || @x > WINDOW_WIDTH
  end

  def update
    raise "Abstract method should be implemented. #{self}"
  end

  def draw
    raise "Abstract method should be implemented. #{self}"
  end

  def mask_on?
    raise "Abstract method should be implemented. #{self}"
  end
end