ActiveAdmin.register Bell do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :place, :password, :note
  #
  # or
  #
  # permit_params do
  #   permitted = [:place, :password, :note]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  index do
    selectable_column

    Bell.column_names.each do |col|
      column col
    end
  end

  Bell.column_names.each do |col|
    filter col
  end
  filter :place, as: :select, collection: BloodborneUtils::PLACE_LIST
end
