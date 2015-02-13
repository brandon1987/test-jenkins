class Core < ActiveRecord::Base
  self.abstract_class = true
  establish_connection :core
end