class Scene_Base
  class << self
    alias_method :abstract_new, :new
    def new(*args)
      raise "Abstract class #{self} cannot instantiate" if self == Scene_Base
      abstract_new(*args)
    end
  end

  def update
    raise "Abstract method should be implemented. #{self}"
  end

  def draw
    raise "Abstract method should be implemented. #{self}"
  end

  def button_down(id)
    raise "Abstract method should be implemented. #{self}"
  end
end