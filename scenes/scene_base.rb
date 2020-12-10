class Scene_Base
  class << self
    alias_method :abstract_new, :new
    def new(*args)
      raise "Abstract class #{self} cannot instantiate" if self == Scene_Base
      abstract_new(*args)
    end
  end

  def initialize

  end

  def update

  end

  def draw

  end

  def button_down(id)

  end
end