class Content < ActiveRecord::Base
  # stabilisco l'associazione con User
  belongs_to :user
end
