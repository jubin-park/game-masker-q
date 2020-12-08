class Scene_Play < Scene_Base
  def initialize
    @objects = Array.new(3)
    @background_image = Gosu::Image.new("images/background.png");
    @objects[0] = Gosu::Image.load_tiles("images/man0.png", 240, 600)
    @objects[1] = Gosu::Image.load_tiles("images/man1.png", 240, 600)
    @objects[2] = Gosu::Image.load_tiles("images/man2.png", 240, 600)
    @x = WINDOW_WIDTH
  end

  def update
    @x -= 1
  end

  def draw
    Gosu.draw_rect(0, 0, WINDOW_WIDTH, WINDOW_HEIGHT, 0xff_eeeeee)
    @background_image.draw(0, 0, 1)
    @objects[0][0].draw(@x, 0, 1)
  end

  def button_down(id)
    
  end
end