class PagesController < ApplicationController
  def philosophy
    set_meta_tags title: '理念', description: '介護職を、日本が誇る専門職として社会に確立する。私たちの理念とミッションをご紹介します。'
  end

  def about
    set_meta_tags title: '運営紹介', description: '一般社団法人 介護の現場からよりより社会を考える会の代表者挨拶と団体概要をご紹介します。'
  end

  def join
    set_meta_tags title: '入会申込', description: '一般社団法人 介護の現場からよりより社会を考える会への入会をご希望の方はこちらからお申し込みください。'
  end

  def create_join
    join_params = params.require(:join).permit(:company_name, :name, :position, :email, :phone, :plan)

    if join_params[:company_name].blank? || join_params[:name].blank? || join_params[:email].blank? || join_params[:phone].blank? || join_params[:plan].blank?
      flash.now[:alert] = "必須項目を入力してください。"
      set_meta_tags title: '入会申込'
      render :join, status: :unprocessable_entity
      return
    end

    begin
      JoinMailer.notify_admin(join_params).deliver_later
      JoinMailer.auto_reply(join_params).deliver_later
    rescue => e
      Rails.logger.error "Mail delivery error: #{e.message}"
    end

    redirect_to join_path, notice: "入会申込を受け付けました。審査のうえ、結果をご連絡させていただきます。"
  end
end
