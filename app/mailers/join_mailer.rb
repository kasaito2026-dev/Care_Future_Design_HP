class JoinMailer < ApplicationMailer
  # 管理者へ入会申込通知
  def notify_admin(join_params)
    @join = join_params
    mail(
      to: ENV.fetch("ADMIN_EMAIL", "info@kaigo-society.org"),
      subject: "【介護の現場からよりよい社会を考える会】入会申込がありました",
      reply_to: @join[:email]
    )
  end

  # 申込者への自動返信
  def auto_reply(join_params)
    @join = join_params
    mail(
      to: @join[:email],
      subject: "【介護の現場からよりよい社会を考える会】入会申込を受け付けました"
    )
  end
end
