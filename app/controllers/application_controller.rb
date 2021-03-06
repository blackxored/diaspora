#   Copyright (c) 2010, Diaspora Inc.  This file is
#   licensed under the Affero General Public License version 3 or later.  See
#   the COPYRIGHT file.

class ApplicationController < ActionController::Base
  #has_mobile_fu
  protect_from_forgery :except => :receive

  # =>before_filter :mobile_except_ipad
  before_filter :set_contacts_and_status, :except => [:create, :update]
  before_filter :count_requests
  before_filter :set_invites
  before_filter :set_locale

  def set_contacts_and_status
    if current_user
      if params[:aspect] == nil || params[:aspect] == 'all'
        @aspect = :all
      else
        @aspect = current_user.aspect_by_id( params[:aspect])
      end

      @aspects = current_user.aspects
      @aspects_dropdown_array = current_user.aspects.collect{|x| [x.to_s, x.id]}
      @contacts = current_user.contacts
    end
  end

  def mobile_except_ipad
    if is_mobile_device?
      if request.env["HTTP_USER_AGENT"].include? "iPad"
        session[:mobile_view] = false 
      else
        session[:mobile_view] = true
      end
    end
  end
  
  def count_requests
    @request_count = current_user.requests_for_me.size if current_user
  end

  def set_invites
    if current_user
      @invites = current_user.invites
    end
  end

  def set_locale
    if current_user
      I18n.locale = current_user.language
    else
      I18n.locale = request.compatible_language_from AVAILABLE_LANGUAGE_CODES
    end
  end
end
