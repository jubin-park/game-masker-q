# encoding: utf-8

require 'scenes/scene_base.rb'

class Scene_Intro < Scene_Base
  def initialize
    @title_image = Gosu::Image.new("images/title816612.png");
    @title_image2 = Gosu::Image.new("images/title2.png")
    @logo_image = Gosu::Image.new("images/logo-en.png")
    @mask_image = Gosu::Image.new("images/mask.png")
    @text = Gosu::Image.from_text("start", 20, width: 100)
    @logo_opacity = 0
    @logo_x = 350.0;
  end

  def update
    @logo_opacity = [@logo_opacity + 2, 0xff].min
    @logo_x = [@logo_x - (@logo_x - 240) / 15.0, 240.0].max
  end

  def draw
    @title_image.draw($game_window.mouse_x / 320 - 8, $game_window.mouse_y / 200 - 6, 0)
    @title_image2.draw(0, 0, 0)
    @logo_image.draw(@logo_x, 120, 0, 1, 1, @logo_opacity << 24 | 0x00_ffffff)
    @mask_image.draw(345, 360, 0, 1, 1, mask_mouse_on? ? 0xff_ffffff : 0xaf_ffffff)
    @text.draw(370, 405, 0, 1, 1, mask_mouse_on? ? 0xff_ffffff : 0xff_000000)
  end

  def mask_mouse_on?
    argb = @mask_image[$game_window.mouse_x.to_i - 345, $game_window.mouse_y.to_i - 360].unpack('C*')
    return (argb[0] << 24 | argb[1] << 16 | argb[2] << 8 | argb[3]) != 0
  end

  def button_down(id)
    case id
    when Gosu::MsLeft
      if mask_mouse_on?
        SceneManager.switch_scene(Scene_Play)
      end
    end
  end
end