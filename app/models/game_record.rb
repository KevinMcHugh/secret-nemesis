class GameRecord < ActiveRecord::Base
  has_many :player_records
  has_many :event_records
end