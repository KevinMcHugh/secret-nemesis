class GameRecord < ActiveRecord::Base
  has_many :player_records

end