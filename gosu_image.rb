class Gosu::Image
  def [](x, y) # Returns a binary string with r/g/b/a as the characters
    @blob ||= self.to_blob
    if x < 0 or x >= width or y < 0 or y >= height
      "\x0\x0\x0\x0" # return transparent pixels by default; you could also return nil
    else
      @blob[(y * width + x) * 4, 4]
    end
  end
end