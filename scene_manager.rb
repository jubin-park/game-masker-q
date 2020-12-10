module SceneManager
  @@scene = nil

  def self.switch_scene(scene)
    @@scene = nil
    @@scene = scene.new
    return
  end

  def self.get_scene()
    return @@scene
  end
end