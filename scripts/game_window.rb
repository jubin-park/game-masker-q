class GameWindow < Gosu::Window
  def initialize
    super WINDOW_WIDTH, WINDOW_HEIGHT
    self.caption = "MaskerQ"
    SceneManager.switch_scene(Scene_Intro)
    return
  end
  
  def update
    SceneManager.get_scene.update
    return
  end
  
  def draw
    SceneManager.get_scene.draw
    return
  end

  def button_down(id)
    SceneManager.get_scene.button_down(id)
    return
  end

  def needs_cursor?
    return true
  end
end