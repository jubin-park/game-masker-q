module SceneManager
  @@scene = nil

  def self.switch_scene(scene)
    @@scene = scene.new
  end

  def self.get_scene()
    @@scene
  end
end