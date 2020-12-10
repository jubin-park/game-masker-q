class PenguinMan < Person
  ENUM_STATE = [
    STATE_MASK = 0,
    STATE_NO_MASK = 1,
    STATE_VERTICAL_CLOSED_MASK = 2,
    STATE_VERTICAL_OPENED_MASK = 3
  ]

  def initialize
    super
    @@images ||= Gosu::Image.load_tiles("images/penguin_man.png", 240, 600)
    @state = ENUM_STATE[rand(ENUM_STATE.length)]
    return
  end

  def update
    case @direction
    when DIRECTION_LEFT
      if @diagnosing
        if @x > WINDOW_WIDTH - 120
          @x -= 6.0
        else
          @x -= @dx
        end
      else
        @dx += 1
        @x -= @dx
      end

    when DIRECTION_RIGHT
      if @diagnosing
        p "right"
      else
        @dx += 1
        @x += @dx
      end

    else
      raise
    end
    return
  end

  def disposed?
    return @x < -240.0 || @x > WINDOW_WIDTH
  end

  def draw
    @@images[@state].draw(@x, 0, 1)
    return
  end

  def passable?
    return @state == STATE_MASK || @state == STATE_VERTICAL_CLOSED_MASK
  end
end