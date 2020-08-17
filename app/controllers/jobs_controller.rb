class JobsController < ApplicationController
  before_action :set_job, only: [:show, :edit, :update, :destroy]

  def index
    @jobs = Job.all.order(pay_max: :desc)
    @job_count_by_company = Job.group(:company_name).count.sort_by(&:last).reverse
  end
end
