class User < ActiveRecord::Base
    has_many :tickets
    has_many :shows, through: :tickets
end