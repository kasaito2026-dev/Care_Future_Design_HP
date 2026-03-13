class ContactMailer < ApplicationMailer
  # 管理者へお問い合わせ内容を通知
  def notify_admin(contact_params)
    @contact = contact_params
    mail(
      to: ENV.fetch("ADMIN_EMAIL", "info@kaigo-society.org"),
      subject: "【介護の現場からよりよい社会を考える会】お問い合わせ",
      reply_to: @contact[:email]
    )
  end

  # 問い合わせ者への自動返信
  def auto_reply(contact_params)
    @contact = contact_params
    mail(
      to: @contact[:email],
      subject: "【介護の現場からよりよい社会を考える会】お問い合わせありがとうございます"
    )
  end
end
