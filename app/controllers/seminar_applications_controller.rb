class SeminarApplicationsController < ApplicationController
  def new
    @seminar = Seminar.find_by!(slug: params[:seminar_slug])
    set_meta_tags title: "#{@seminar.title} 参加申込", description: "#{@seminar.title}への参加申込フォームです。"
  end

  def create
    @seminar = Seminar.find_by!(slug: params[:seminar_slug])
    app_params = params.require(:application).permit(:company_name, :name, :position, :email, :phone, :message)

    if app_params[:name].blank? || app_params[:email].blank? || app_params[:phone].blank?
      flash.now[:alert] = "必須項目を入力してください。"
      render :new, status: :unprocessable_entity
      return
    end

    begin
      SeminarApplicationMailer.notify_admin(app_params, @seminar).deliver_now
      SeminarApplicationMailer.auto_reply(app_params, @seminar).deliver_now
    rescue => e
      Rails.logger.error "Mail delivery error: #{e.message}"
    end

    redirect_to seminar_thanks_path(@seminar.slug)
  end

  def thanks
    @seminar = Seminar.find_by!(slug: params[:seminar_slug])
    set_meta_tags title: '申込完了 | セミナー参加'
  end
end
