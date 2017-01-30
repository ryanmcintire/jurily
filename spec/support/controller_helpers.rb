module ControllerHelpers

  #
  # Creates a helper method to sign_in a user for a specific scope.
  # Can be used such as sign_in create(:user) to simulate a signed in user.
  # sign_in nil to simulate anonymous user.

  def login_with(user = double('user'), scope = :user)
    current_user = "current_#{scope}".to_sym
    if user.nil?
      allow(request.env['warden']).to receive(:authenticate!).and_throw(:warden, {scope: scope})
      allow(controller).to receive(current_user).and_return(nil)
    else
      allow(request.env['warden']).to receive(:authenticate!).and_return(user)
      allow(controller).to receive(current_user).and_return(user)
    end
  end
end