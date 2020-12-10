class TrapezoidJaw < Person
  ENUM_STATE = [
    STATE_MASK = 0,
    STATE_FORHEAD_MASK = 1,
    STATE_NO_MASK = 2,
    STATE_FORHEAD_NO_MASK = 3
  ]

  def initialize
    super
    @@images ||= Gosu::Image.load_tiles("images/trapezoid_jaw.png", 240, 600)
    @@maskitem_image ||= Gosu::Image.new("images/mask_item.png")
    @state = [STATE_MASK, STATE_NO_MASK][rand(2)]
    @has_maskitem = if @state == STATE_NO_MASK
      [true, false][rand(2)]
    else
      false
    end
    @x = WINDOW_WIDTH.to_f
    @angle = 0.0
    @dx = 2.0
    @da = 1.0
  end

  def update
    @da *= -1 if @angle > 40 || @angle < -20
    @angle += @da   

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
  end

  def hair_up
    case @state
    when STATE_MASK
      @state = STATE_FORHEAD_MASK
    when STATE_NO_MASK
      @state = STATE_FORHEAD_NO_MASK
    end
  end

  def hair_down
    case @state
    when STATE_FORHEAD_MASK
      @state = STATE_MASK
    when STATE_FORHEAD_NO_MASK
      @state = STATE_NO_MASK
    end
  end

  def equip_mask
    if @has_maskitem
      @state = STATE_FORHEAD_MASK
      @has_maskitem = false
    end
  end

  def disposed?
    @x < -240.0 || @x > WINDOW_WIDTH
  end

  def draw
    @@images[@state].draw(@x, 0, 1)
    if @has_maskitem && (@state == STATE_FORHEAD_MASK || @state == STATE_FORHEAD_NO_MASK)
      #@@maskitem_image.draw(@x + 70, 140, 2)
      @@maskitem_image.draw_rot(@x + 110, 140, 2, @angle, 0.4, 0.1)
    end
  end

  def passable?
    return @state == STATE_MASK || @state == STATE_FORHEAD_MASK
  end
end