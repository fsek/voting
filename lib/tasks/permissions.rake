namespace 'permissions' do
  desc 'Loading all models and their related controller methods inpermissions table.'
  task(:load => :environment) do
    arr = []
    #load all the controllers
    controllers = Dir.new("#{Rails.root}/app/controllers").entries
    controllers.each do |entry|
      if entry =~ /_controller/ && entry != 'application_controller.rb'
        #check if the controller is valid
        arr << entry.camelize.gsub('.rb', '').constantize
      elsif entry =~ /^[a-z]*$/ #namescoped controllers
        Dir.new("#{Rails.root}/app/controllers/#{entry}").entries.each do |x|
          if x =~ /_controller/ && entry != 'application_controller.rb'
            arr << "#{entry.titleize}::#{x.camelize.gsub('.rb', '')}".constantize
          end
        end
      end
    end

    SKIP = ['alert_create', 'alert_update', 'alert_destroy', 'model_name']
    arr.each do |controller|
      #only that controller which represents a model
      if controller.permission
        write_controller_permissions(controller.permission, controller)
      elsif controller.to_s == 'Admin::VoteUsersController'
        write_controller_permissions('vote_user', controller)
      end
    end
  end
end

def write_controller_permissions(subject, controller)
  write_permission(subject, 'manage') #add permission to do CRUD for every model.
  controller.action_methods.each do |method|
    if method =~ /^([A-Za-z\d*]+)+([\w]*)+([A-Za-z\d*]+)$/ #add_user, add_user_info, Add_user, add_User
      _, cancan_action = eval_cancan_action(method)
      unless SKIP.include?(cancan_action)
        write_permission(subject, cancan_action)
      end
    end
  end
end

# this method returns the cancan action for the action passed.
def eval_cancan_action(action)
  case action.to_s
  when 'index'
    name = 'list'
    cancan_action = 'index' #<strong>let the cancan action be the actual method name</strong>
    action_desc = I18n.t(:list)
  when 'new', 'create'
    name = 'new and create'
    cancan_action = 'create'
    action_desc = I18n.t :create
  when 'show'
    name = 'view'
    cancan_action = 'view'
    action_desc = I18n.t :view
  when 'edit', 'update'
    name = 'edit and update'
    cancan_action = 'update'
    action_desc = I18n.t :update
  when 'delete', 'destroy'
    name = 'delete'
    cancan_action = 'destroy'
    action_desc = I18n.t :destroy
  else
    name = action.to_s
    cancan_action = action.to_s
    action_desc = 'Other: ' < cancan_action
  end
  return name, cancan_action
end

# check if the permission is present else add a new one.
def write_permission(model, cancan_action)
  Permission.find_or_create_by(subject_class: model, action: cancan_action)
end
