class StaticPagesController < ApplicationController
  before_action :authenticate_admin_user!, only: [:import_content]

  def home
    @success_stories = SuccessStory.limit(4)
    @courses = Course.badges
  end

  def about; end

  def faq; end

  def terms_of_use; end

  def success_stories
    @success_stories = SuccessStory.all
  end

  def import_content
    github_paths = Lesson.pluck(:github_path)
    UpdateLessonContentJob.perform_async(github_paths)
    redirect_to root_path, notice: 'Curriculum lesson import job running 🐢 Track the progress at /sidekiq'
  end
end
