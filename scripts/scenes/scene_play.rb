require 'objects/person.rb'
require 'objects/hair_loss.rb'
require 'objects/penguin_man.rb'
require 'objects/trapezoid_jaw.rb'

class Scene_Play < Scene_Base
  ENUM_SCORE = [
    SCORE_LEFT_PASS = 200,
    SCORE_LEFT_WARNING = (-100),
    SCORE_RIGHT_PASS = 200,
    SCORE_RIGHT_WARNING = (-100),
    SCORE_BONUS = 50
  ]

  ENUM_ZORDER = []

  WARNING_FRAME_DURATION = 1800
  MAX_LIFE_COUNT = 3

  def initialize
    @start_time = Gosu.milliseconds
    @end_time = 0
    @score = 0
    @life_count = MAX_LIFE_COUNT
    @person_count = 1
    @pass_count = 0

    @success_sample = SoundManager.load_sample("sounds/success.wav")
    @warning_sample = SoundManager.load_sample("sounds/warning.wav")
    @gameover_sample = SoundManager.load_sample("sounds/gameover.wav")

    @background_image = Gosu::Image.new("images/background.png");
    @life_images = Gosu::Image.load_tiles("images/life.png", 64, 64)
    @time_text = Gosu::Font.new(40, :name => "Malgun Gothic", :bold => true)
    @score_text = Gosu::Font.new(32, :name => "Malgun Gothic", :bold => true)
    @warning_frame_image = Gosu::Image.new("images/warning_frame.png")
    @warning_frame_duration = 0
    @warning_frame_opacity = 0x0
    @d_opacity = 10
    
    @person = generate_random_person

    @result_image = Gosu::Image.from_text("Game Over", 60, :width => WINDOW_WIDTH / 2, :align => :center, :italic => true)
    @result_replay_image = Gosu::Image.from_text("Replay?", 36, :width => 128, :align => :center, :italic => true)
    @result_time_text = Gosu::Font.new(28, :name => "Malgun Gothic", :bold => true)
    @result_score_text = Gosu::Font.new(28, :name => "Malgun Gothic", :bold => true)
    @result_passed_number_text = Gosu::Font.new(28, :name => "Malgun Gothic", :bold => true)
    @result_failed_number_text = Gosu::Font.new(28, :name => "Malgun Gothic", :bold => true)

    $bgm.play(true)

    return
  end

  def update
    if !game_over?
      @person.update
      if @person.disposed?
        if @person.diagnosing?
          if @person.mask_on?
            p "PERFECT"
            @score += get_weight_score(SCORE_LEFT_PASS)
            @pass_count += 1
            @success_sample.play
          else
            p "BAD"
            @score += get_inverse_weight_score(SCORE_LEFT_WARNING)
            init_warning_frame
            @life_count = [@life_count - 1, -1].max
            if game_over?
              $bgm.stop
              @gameover_sample.play
            else
              @warning_sample.play
            end
          end
          @person.finalize_diagnosis
        end
        @person_count += 1
        level = get_game_level
        @person = nil
        @person = generate_random_person
        @person.dx += level * 0.4
        p "level = #{level} dx = #{@person.dx}"
      end
      if Gosu.milliseconds < @warning_frame_duration
        @d_opacity *= -1 if @warning_frame_opacity > 0xff || @warning_frame_opacity < 0
        @warning_frame_opacity += @d_opacity
      else
        @warning_frame_opacity = 0
        @d_opacity = @d_opacity.abs
      end
    else

    end
    return
  end

  def draw
    @background_image.draw(0, 0, 1)
    @person.draw

    if game_over?
      Gosu.draw_rect(0, 0, WINDOW_WIDTH, WINDOW_HEIGHT, 0xa0_000000, 100)
      @result_image.draw(200, 200, 101)
      t = @end_time
      @result_time_text.draw_markup(sprintf("Playing Time: <c=7fdbda>%02d:%02d.%02d\"</c>", t / 60000, (t / 1000) % 60, t % 1000 / 10),
        278, 270, 101)
      @result_score_text.draw_markup("Score: <c=ade498>#{@score}</c>",
        354, 300, 101)
      @result_passed_number_text.draw_markup("Pass: <c=ede682>#{@pass_count}</c>", 366, 330, 101)
      @result_failed_number_text.draw_markup("Fail: <c=febf63>#{@person_count - @pass_count}</c>", 376, 360, 101)
      @result_replay_image.draw(336, 400, 101, 1.0, 1.0, replay_mouse_on? ? 0xff_ff4646 : 0xff_ffb396)
    else
      @end_time = Gosu.milliseconds - @start_time
      for i in 0...@life_count
        @life_images[0].draw(8 + i * 68, 8, 2)
      end
      for i in @life_count...MAX_LIFE_COUNT
        @life_images[1].draw(8 + i * 68, 8, 2)
      end
      t = @end_time
      @time_text.draw_text_rel(sprintf("%02d:%02d.%02d\"", t / 60000, (t / 1000) % 60, t % 1000 / 10),
      WINDOW_WIDTH / 2, 20, 2,
        0.5, 0.0,
        1.0, 1.0, 0xff_404040)
      @score_text.draw_text_rel("Score #{@score}",
        WINDOW_WIDTH - 20, 20, 2,
        1.0, 0.0,
        1.0, 1.0, 0xff_111111)
      @warning_frame_image.draw(0, 0, 99, 1.0, 1.0, ([[@warning_frame_opacity, 0x0].max, 0xff].min << 24) | 0x00_ffffff)
    end   
    
    return
  end

  def button_down(id)
    case id
    when Gosu::KB_LEFT
      return if !@person.diagnosing?
      if @person.mask_on?
        p "PERFECT"
        @score += get_weight_score(SCORE_LEFT_PASS)
        @pass_count += 1
        @success_sample.play
      else
        p "BAD"
        @score += get_inverse_weight_score(SCORE_LEFT_WARNING)
        init_warning_frame
        @life_count = [@life_count - 1, -1].max
        if game_over?
          $bgm.stop
          @gameover_sample.play
        else
          @warning_sample.play
        end
      end
      @person.move_left
      @person.finalize_diagnosis

    when Gosu::KB_RIGHT
      return if !@person.diagnosing?
      if @person.mask_on?
        p "BAD"
        @score += get_inverse_weight_score(SCORE_RIGHT_WARNING)
        init_warning_frame
        @life_count = [@life_count - 1, -1].max
        if game_over?
          $bgm.stop
          @gameover_sample.play
        else
          @warning_sample.play
        end
      else
        p "PERFECT"
        @score += get_weight_score(SCORE_RIGHT_PASS)
        @pass_count += 1
        @success_sample.play
      end
      @person.move_right
      @person.finalize_diagnosis

    when Gosu::KB_UP
      return if !@person.diagnosing?
      if @person.is_a?(HairLoss)
        @person.mask_up
      elsif @person.is_a?(TrapezoidJaw)
        @person.hair_up 
      end

    when Gosu::KB_DOWN
      return if !@person.diagnosing?
      if @person.is_a?(HairLoss)
        @person.mask_down
      elsif @person.is_a?(TrapezoidJaw)
        @person.hair_down
      end

    when Gosu::KB_SPACE
      return if !@person.diagnosing?
      if @person.is_a?(TrapezoidJaw)
        if @person.equip_mask
          p "bonus score #{SCORE_BONUS}"
          @score += SCORE_BONUS
        elsif @person.try_give_life
          @life_count = [@life_count + 1, MAX_LIFE_COUNT].min
          @success_sample.play(1, 2)
        end
      end

    when Gosu::MS_LEFT
      if game_over? && replay_mouse_on?
        $bgm.stop
        SceneManager.switch_scene(Scene_Play)
      end

    else
      p "button_down = #{id}"
    end
    return
  end

private
  def init_warning_frame
    @warning_frame_duration = Gosu.milliseconds + WARNING_FRAME_DURATION
    @warning_frame_opacity = 0x0
  end

  def generate_random_person
    persons = [HairLoss, PenguinMan, TrapezoidJaw]
    return persons[rand(persons.length)].new
  end

  def game_over?
    return @life_count < 0
  end

  def replay_mouse_on?
    return $game_window.mouse_x >= 336 && $game_window.mouse_x < 336 + 128 &&
      $game_window.mouse_y >= 400 && $game_window.mouse_y < 400 + 36
  end

  def get_weight_score(score)
    return (score * [0.0, @person.x / WINDOW_WIDTH].max).to_i
  end

  def get_inverse_weight_score(score)
    return (score * [1.0, @person.x / WINDOW_WIDTH].min).to_i
  end

  def get_game_level
    return (Gosu.milliseconds - @start_time) / 6000
  end
end