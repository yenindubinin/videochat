class MessagesController < ApplicationController

  layout false
  def send_message_to_lawyer
    @lawyer = User.find params[:lawyer_id]
    message = Message.new(body: params[:email_msg], client_id: current_user.try(:id), lawyer_id: @lawyer.id)
    message.send! unless current_user.nil? 
    session[:message] = message if message.is_a?(Message) && current_user.nil?
    render :json => { :result => current_user.present? }
  end

  def clear_session_message
    session.delete(:message) if session[:message]
    render :nothing => true
  end   
end