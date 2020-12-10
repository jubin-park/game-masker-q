require 'objects/person.rb'
require 'objects/hair_loss.rb'
require 'objects/penguin_man.rb'
require 'objects/trapezoid_jaw.rb'

class Scene_Play < Scene_Base
  ENUM_SCORE = [
    SCORE_LEFT_PASS = 100,
    SCORE_LEFT_DAMAGE = (-50),
    SCORE_RIGHT_PASS = 100,
    SCORE_RIGHT_DAMAGE = (-50),
  ]

  DAMAGE_FRAME_DURATION = 1800

  def initialize
    @start_time = Gosu.milliseconds
    @background_image = Gosu::Image.new("images/background.png");
    @person = generate_random_person
    @time_text = Gosu::Font.new(40, :name => "Malgun Gothic", :bold => true)
    @time = Gosu.milliseconds + 60000
    @score_text = Gosu::Font.new(32, :name => "Malgun Gothic", :bold => true)
    @score = 0
    $bgm.play(true)
    @damage_frame_image = Gosu::Image.new("images/damage_frame.png")
    @damage_frame_duration = 0
    @damage_frame_opacity = 0x0
    @d_opacity = 10
    return
  end

  def generate_random_person
    persons = [HairLoss, PenguinMan, TrapezoidJaw]
    return persons[rand(persons.length)].new
  end

  def update
    @person.update
    if @person.disposed?
      if @person.diagnosing?
        if @person.passable?
          p "PERFECT"
          @score += SCORE_LEFT_PASS
        else
          p "BAD"
          @score += SCORE_LEFT_DAMAGE
          @damage_frame_duration = Gosu.milliseconds + DAMAGE_FRAME_DURATION
          @damage_frame_opacity = 0x0
        end
        @person.finalize_diagnosis
      end
      @person = nil
      @person = generate_random_person
    end
    if Gosu.milliseconds < @damage_frame_duration
      @d_opacity *= -1 if @damage_frame_opacity > 0xff || @damage_frame_opacity < 0
      @damage_frame_opacity += @d_opacity
    else
      @damage_frame_opacity = 0
      @d_opacity = @d_opacity.abs
    end
    return
  end

  def draw
    Gosu.draw_rect(0, 0, WINDOW_WIDTH, WINDOW_HEIGHT, 0xff_eeeeee)
    @background_image.draw(0, 0, 1)
    t = Gosu.milliseconds - @start_time
    @time_text.draw_text_rel(sprintf("%02d:%02d.%02d", t / 60000, (t / 1000) % 60, t % 1000 / 10),
    WINDOW_WIDTH / 2, 20, 2,
      0.5, 0.0,
      1.0, 1.0, 0xff_404040)
    @score_text.draw_text_rel("Score (#{@score})",
      WINDOW_WIDTH - 20, 20, 2,
      1.0, 0.0,
      1.0, 1.0, 0xff_111111)
    @person.draw
    @damage_frame_image.draw(0, 0, 99, 1.0, 1.0, ([[@damage_frame_opacity, 0x0].max, 0xff].min << 24) | 0x00_ffffff)
    return
  end

  def button_down(id)
    case id
    when Gosu::KB_LEFT
      if @person.diagnosing?
        if @person.passable?
          p "PERFECT"
          @score += SCORE_LEFT_PASS
        else
          p "BAD"
          @score += SCORE_LEFT_DAMAGE
          @damage_frame_duration = Gosu.milliseconds + DAMAGE_FRAME_DURATION
          @damage_frame_opacity = 0x0
        end
        @person.move_left
        @person.finalize_diagnosis
      end

    when Gosu::KB_RIGHT
      if @person.diagnosing?
        if @person.passable?
          p "BAD"
          @score += SCORE_RIGHT_DAMAGE
          @damage_frame_duration = Gosu.milliseconds + DAMAGE_FRAME_DURATION
          @damage_frame_opacity = 0x0
        else
          p "PERFECT"
          @score += SCORE_RIGHT_PASS
        end
        @person.move_right
        @person.finalize_diagnosis
      end

    when Gosu::KB_UP
      if @person.is_a?(HairLoss)
        @person.mask_up
      elsif @person.is_a?(TrapezoidJaw)
        @person.hair_up 
      end

    when Gosu::KB_DOWN
      if @person.is_a?(HairLoss)
        @person.mask_down
      elsif @person.is_a?(TrapezoidJaw)
        @person.hair_down
      end

    when Gosu::KB_SPACE
      @person.equip_mask if @person.is_a?(TrapezoidJaw)

    end
    return
  end
end