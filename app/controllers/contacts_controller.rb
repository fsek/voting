# frozen_string_literal: true

class ContactsController < ApplicationController
  authorize_resource class: false

  def index
    @message = Message.new
  end

  def mail
    @message = Message.new(message_params)

    if @message.send!
      redirect_to contacts_path, notice: t('contact.message_sent')
    else
      flash[:alert] = t('contact.something_wrong')
      render :index, status: 422
    end
  end

  private

  def message_params
    params.require(:message).permit(:name, :email, :message)
  end
end
