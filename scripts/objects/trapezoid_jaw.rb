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
    @has_maskitem = [true, false][rand(2)]
    @angle = 0.0
    @da = 1.0
    return
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
    return
  end

  def draw
    @@images[@state].draw(@x, 0, 1)
    if @has_maskitem && (@state == STATE_FORHEAD_MASK || @state == STATE_FORHEAD_NO_MASK)
      @@maskitem_image.draw_rot(@x + 110, 140, 2, @angle, 0.4, 0.1)
    end
    return
  end

  def mask_on?
    return @state == STATE_MASK || @state == STATE_FORHEAD_MASK
  end

  def hair_up
    case @state
    when STATE_MASK
      @state = STATE_FORHEAD_MASK

    when STATE_NO_MASK
      @state = STATE_FORHEAD_NO_MASK

    end
    return
  end

  def hair_down
    case @state
    when STATE_FORHEAD_MASK
      @state = STATE_MASK

    when STATE_FORHEAD_NO_MASK
      @state = STATE_NO_MASK

    end
    return
  end

  def equip_mask
    if @has_maskitem && !mask_on?
      @state = STATE_FORHEAD_MASK
      @has_maskitem = false
      return true
    end
    return false
  end

  def try_give_life
    if @has_maskitem && mask_on?
      @has_maskitem = false
      return true
    end
    return false
  end
end