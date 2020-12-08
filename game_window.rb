class GameWindow < Gosu::Window
  def initialize
    super WINDOW_WIDTH, WINDOW_HEIGHT
    self.caption = "MaskerQ"
    SceneManager.switch_scene(Scene_Intro)
  end
  
  def update
    SceneManager.get_scene.update
  end
  
  def draw
    SceneManager.get_scene.draw
  end

  def button_down(id)
    SceneManager.get_scene.button_down(id)
  end

  def needs_cursor?
    true
  end
end