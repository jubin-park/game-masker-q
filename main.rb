$LOAD_PATH << Dir.pwd

require 'gosu'
require 'gosu_image.rb'
require 'game_window.rb'
require 'scene_manager.rb'
require 'sound_manager.rb'
require 'scenes/scene_intro.rb'
require 'scenes/scene_play.rb'

WINDOW_WIDTH, WINDOW_HEIGHT = 800, 600
$bgm = SoundManager.load_song("sounds/duskwalkin.wav");
#$bgm.volume = 0.05

$game_window = GameWindow.new
$game_window.show if __FILE__ == $0