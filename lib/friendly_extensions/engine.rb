module FriendlyExtensions
  class Engine < Rails::Engine
    engine_name "friendly_extensions"
    
    initializer "friends.labeled_form_helper" do
      ActionView::Helpers::FormBuilder.send(:include, FriendsLabeledFormHelper)
    end  
    
  end
end    