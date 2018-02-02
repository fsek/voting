# frozen_string_literal: true

class MessagesController < ApplicationController
  def show
    @message = Message.new
  end

  def create
    @message = Message.new(message_params)

    if @message.create
      redirect_to(message_path, notice: t('.success'))
    else
      flash[:alert] = t('.error')
      render(:show, status: 422)
    end
  end

  private

  def message_params
    params.require(:message).permit(:name, :email, :message)
  end
end
