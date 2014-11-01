class CommentMailer < ActionMailer::Base
  default from: "support@rocketfuelleak.com"

  def new_application_comment(app, comment)
    @app = app
    @appuser = @app.user
    @user = comment.user
    @content = comment.content
    @title = "#{@user} has commented on #{@appuser}'s application"
    subject = "[RFL] #{@user}'s comment on #{@appuser}'s application"
    to = User.with_any_role(:admin, :officer).map(&:email)
    to << @appuser.email unless to.include? @appuser.email
    to.delete(@user.email)
    mail(subject: subject, to: to)
  end
end
