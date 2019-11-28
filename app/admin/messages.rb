ActiveAdmin.register Message do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :text, :user, :bell_id
  #
  # or
  #
  # permit_params do
  #   permitted = [:text, :user, :bell_id]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  permit_params :text, :user, :bell_id

  Message.column_names.each do |col|
    filter col
  end
  filter :bell_id, as: :select
end
