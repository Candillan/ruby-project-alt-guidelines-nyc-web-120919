class Show < ActiveRecord::Base
    has_many :tickets, dependent: :destroy
    has_many :users, through: :tickets, dependent: :destroy
    has_many :roles, dependent: :destroy
    has_many :actors, through: :roles, dependent: :destroy
end