class JobsController < ApplicationController
  before_action :set_job, only: [:show, :edit, :update, :destroy]

  def index
    @jobs = Job.all.order(fee_max: :desc)
    @job_count_by_company = Job.group(:company_name).count.sort_by(&:last).reverse
  end

  def exec_batch
    # heroku free dyno web だけでバッチ実行するため
    Job.scrape
    redirect_to jobs_path
  end
end
