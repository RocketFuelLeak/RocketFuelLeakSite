# Preview all emails at http://localhost:3000/rails/mailers/comment_mailer
class CommentMailerPreview < ActionMailer::Preview
    def new_application_comment
        # http://localhost:3000/rails/mailers/comment_mailer/new_application_comment
        app = Application.first
        CommentMailer.new_application_comment(app, app.comments.first)
    end
end
