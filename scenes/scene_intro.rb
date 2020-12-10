require 'scenes/scene_base.rb'

class Scene_Intro < Scene_Base
  def initialize
    @footstep_sample = Gosu::Sample.new("sounds/footstep.wav")
    $bgm = Gosu::Song.new("sounds/duskwalkin.wav");

    @title_image = Gosu::Image.new("images/title816612.png");
    @title_image2 = Gosu::Image.new("images/title2.png")
    @logo_image = Gosu::Image.new("images/logo-en.png")
    @mask_image = Gosu::Image.new("images/mask.png")
    @text = Gosu::Image.from_text("start", 20, width: 100)
    @logo_opacity = 0
    @logo_x = 365.0;

    @title_x = 429.0
    @title_theta = 0.0
    @title_opacity = 0
    @phase = 0
  end

  def update
    case @phase
    when 0
      if @title_x > 0.0
        @title_theta += Math::PI * 0.05
        @footstep_sample.play(1, 1.0) if @title_x % 108 == 3
      else
        @title_theta = Math::PI * 0.5
        @phase = 1
      end
      @title_x = [@title_x - 3.0, 0.0].max

    when 1
      @title_opacity = [@title_opacity + 5, 0xff].min
      @phase = 2 if @title_opacity >= 0xff
      $bgm.play(true) if @title_opacity >= 0xff

    when 2
      @logo_opacity = [@logo_opacity + 2, 0xff].min
      @logo_x = [@logo_x - (@logo_x - 240) / 15.0, 240].max
    else
      raise "Unvalid phase value"
    end
  end

  def draw
    case @phase
    when 0
      Gosu.draw_rect(0, 0, WINDOW_WIDTH, WINDOW_HEIGHT, 0xff_ffffff)
      @title_image2.draw(@title_x, 20 - 20 * Math.sin(@title_theta), 0)

    when 1
      Gosu.draw_rect(0, 0, WINDOW_WIDTH, WINDOW_HEIGHT, 0xff_ffffff)
      @title_image.draw($game_window.mouse_x / 320 - 8, $game_window.mouse_y / 200 - 6, 0, 1.0, 1.0, @title_opacity << 24 | 0x00_ffffff)
      @title_image2.draw(0, 0, 0)

    when 2
      @title_image.draw($game_window.mouse_x / 320 - 8, $game_window.mouse_y / 200 - 6, 0, 1.0, 1.0, 0xff_ffffff)
      @title_image2.draw(0, 0, 0)
      @logo_image.draw(@logo_x, 120, 0, 1, 1, @logo_opacity << 24 | 0x00_ffffff)
      @mask_image.draw(345, 360, 0, 1, 1, mask_mouse_on? ? 0xff_ffffff : 0xaf_ffffff)
      @text.draw(370, 405, 0, 1, 1, mask_mouse_on? ? 0xff_ffffff : 0xff_000000)
    else
      raise "Unvalid phase value"
    end
  end

  def mask_mouse_on?
    argb = @mask_image[$game_window.mouse_x.to_i - 345, $game_window.mouse_y.to_i - 360].unpack('C*')
    return (argb[0] << 24 | argb[1] << 16 | argb[2] << 8 | argb[3]) != 0
  end

  def button_down(id)
    case id
    when Gosu::MS_LEFT
      if mask_mouse_on?
        SceneManager.switch_scene(Scene_Play)
      end
    end
  end
end