class RegistrationsController < Devise::RegistrationsController

  #before_filter :configure_permitted_parameters

  def new
    build_resource({})
    self.resource.user_detail = UserDetail.new #(user_contact_info: UserContactInfo.new)
    respond_with self.resource
  end


  def create
    puts 'howdy'
    super
  end

  protected
  def after_sign_up_path_for(resource)
    #todo - set page....
    new_profile_url
  end

  def sign_up_params
    permitted = [
        :email, :password, :password_confirmation,
        :user_detail_attributes => [
            :first_name,
            :last_name
        ]
    ]
    params.require(resource_name).permit(permitted)
  end


  # def configure_permitted_parameters
  #   puts 'made it?'
  #   devise_parameter_sanitizer.permit(:sign_up) do |user_params|
  #     puts 'in here?'
  #     user_params.permit(
  #         :email, :password, :password_confirmation,
  #         :user_detail => [
  #             :first_name,
  #             :last_name
  #         ]
  #     )
      #     :last_name,
      #     :user_contact_info => [
      #         :address1,
      #         :address2,
      #         :city,
      #         :state,
      #         :zipcode
      #     ]
      # ]
  #
  #   end
  # end


end