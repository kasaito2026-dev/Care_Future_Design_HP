class SeminarApplicationMailer < ApplicationMailer
  # 管理者へセミナー申込通知
  def notify_admin(app_params, seminar)
    @app = app_params
    @seminar = seminar
    mail(
      to: ENV.fetch("ADMIN_EMAIL", "info@kaigo-society.org"),
      subject: "【セミナー申込】#{@seminar.title}に参加申込がありました",
      reply_to: @app[:email]
    )
  end

  # 申込者への自動返信
  def auto_reply(app_params, seminar)
    @app = app_params
    @seminar = seminar
    mail(
      to: @app[:email],
      subject: "【セミナー申込】#{@seminar.title}の参加申込を受け付けました"
    )
  end
end
