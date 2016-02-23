class Operation < ActiveRecord::Base
  belongs_to :workshop;
  has_many :action;
  has_many :operation_cost;
end
