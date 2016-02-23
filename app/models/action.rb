class Action < ActiveRecord::Base
  belongs_to :operation;
  belongs_to :worker;
  belongs_to :linkedoperation, :class_name => 'Operation', :foreign_key => 'linkedoperation_id';
  belongs_to :linkedworker, :class_name => 'Worker', :foreign_key => 'linkedworker_id';
  has_many :workshop, through: :operation
end
