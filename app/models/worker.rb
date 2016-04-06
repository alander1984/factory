class Worker < ActiveRecord::Base
  has_many :action
  has_many :operation, through: :action
  def fullname
    "#{fname} #{sname}"
  end

end
