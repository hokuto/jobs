json.extract! job, :id, :title, :category, :company_name, :pay_min, :pay_max, :created_at, :updated_at
json.url job_url(job, format: :json)
