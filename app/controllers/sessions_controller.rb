class SessionsController < Devise::SessionsController
  after_filter :set_flash_now

  private

  def set_flash_now
    if flash.key? :notice
      flash.now[:notice] = flash[:notice]
      flash.delete :notice
    end

    puts flash

  end


end