module SoundManager
  module_function

  @@song_caches = Hash.new # <String, Gosu::Song>
  @@sample_caches = Hash.new # <String, Gosu::Sample>

  def load_song(filename)
    return @@song_caches[filename] ||= Gosu::Song.new(filename)
  end

  def load_sample(filename)
    return @@sample_caches[filename] ||= Gosu::Sample.new(filename)
  end
end