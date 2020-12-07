require 'gosu'

$LOAD_PATH << Dir.pwd

require 'gosu_image.rb'

class GameWindow < Gosu::Window
  def initialize
    super 800, 600
    self.caption = "MaskerQ"
    @title_image = Gosu::Image.new("images/title816612.png");
    @title_image2 = Gosu::Image.new("images/title2.png")
    @logo_image = Gosu::Image.new("images/logo.png")
    @mask_image = Gosu::Image.new("images/mask.png")
    @logo_opacity = 0
    @logo_x = 300;
  end
  
  def update
    @logo_opacity = [@logo_opacity + 2, 0xff].min
    @logo_x = [@logo_x * 0.99 + 2, 240].max
    argb = @mask_image[mouse_x.to_i - 345, mouse_y.to_i - 360].unpack('C*')
    @mouse_on = (argb[0] << 24 | argb[1] << 16 | argb[2] << 8 | argb[3]) != 0
  end
  
  def draw
    @title_image.draw(-8 + mouse_x / 320, -6 + mouse_y / 200, 0)
    @title_image2.draw(0, 0, 0)
    @logo_image.draw(@logo_x, 120, 0, 1, 1, @logo_opacity << 24 | 0x00_ffffff)
    if @mouse_on
      @mask_image.draw(345, 360, 0, 1, 1, 0xff_ffff00)
    else
      @mask_image.draw(345, 360, 0, 1, 1, 0xff_ffffff)
    end
  end

  def needs_cursor?
    true
  end

  def button_down(id)
    case id
    when Gosu::MsLeft

      if @mouse_on
        p "!!!"
      end
    end
  end
end

GameWindow.new.show