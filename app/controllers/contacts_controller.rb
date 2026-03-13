class ContactsController < ApplicationController
  def new
    set_meta_tags title: 'お問い合わせ', description: 'お問い合わせはこちらのフォームからお気軽にご連絡ください。'
  end

  def create
    contact_params = params.require(:contact).permit(:company_name, :name, :position, :email, :phone)

    if contact_params[:company_name].blank? || contact_params[:name].blank? || contact_params[:email].blank? || contact_params[:phone].blank?
      flash.now[:alert] = "必須項目を入力してください。"
      render :new, status: :unprocessable_entity
      return
    end

    begin
      ContactMailer.notify_admin(contact_params).deliver_now
      ContactMailer.auto_reply(contact_params).deliver_now
    rescue => e
      Rails.logger.error "Mail delivery error: #{e.message}"
    end

    redirect_to contact_path, notice: "お問い合わせありがとうございます。5営業日以内にご連絡させていただきます。"
  end
end
