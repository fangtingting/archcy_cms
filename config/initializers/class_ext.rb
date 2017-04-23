class ActiveRecord::Base

  # belongs_to :creator, :class_name => "User", :foreign_key => "created_by"
  # belongs_to :updater, :class_name => "User", :foreign_key => "updated_by"
 
  # def update
  #   return(super) unless auditable?
  #   self.updated_by=User.current_user.id if User.current_user
  #   super
  # end

  # def create
  #   return(super) unless auditable?
  #   self.created_by=User.current_user.id if User.current_user
  #   super rescue nil
  # end

  # def auditable?
  #   self.attribute_names.include?('updated_by') and self.attribute_names.include?('created_by') rescue false
  # end

end
