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

  def initialize
    @background_image = Gosu::Image.new("images/background.png");
    @person = generate_random_person
    @score_text = Gosu::Font.new(40, :name => "Malgun Gothic", :bold => true)
    @score = 0
    $bgm.play(true)
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
        end
        @person.finalize_diagnosis
      end
      @person = nil
      @person = generate_random_person
    end
    return
  end

  def draw
    Gosu.draw_rect(0, 0, WINDOW_WIDTH, WINDOW_HEIGHT, 0xff_eeeeee)
    @background_image.draw(0, 0, 1)
    @score_text.draw_text_rel("Score #{@score}", WINDOW_WIDTH - 20, 20, 2, 1, 0, 1.0, 1.0, 0xff_111111)
    @person.draw
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
        end
        @person.move_left
        @person.finalize_diagnosis
      end

    when Gosu::KB_RIGHT
      if @person.diagnosing?
        if @person.passable?
          p "BAD"
          @score += SCORE_RIGHT_DAMAGE
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