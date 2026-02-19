# frozen_string_literal: true

puts "Seeding database..."

# Categories
categories = %w[Engineering Design Marketing Sales Product Finance Operations Customer\ Support Data\ Science DevOps].map do |name|
  Category.find_or_create_by!(name: name)
end
puts "  Created #{categories.size} categories"

# Admin
admin = User.find_or_create_by!(email: "admin@jobboard.test") do |u|
  u.password = "password123"
  u.full_name = "Admin User"
  u.role = :admin
end
puts "  Created admin: admin@jobboard.test / password123"

# Employers
employers_data = [
  { email: "jane@techcorp.test", full_name: "Jane Smith", company_name: "TechCorp Inc", bio: "Leading technology company specializing in cloud infrastructure." },
  { email: "bob@startupxyz.test", full_name: "Bob Johnson", company_name: "StartupXYZ", bio: "Fast-growing fintech startup disrupting payments." },
  { email: "maria@designstudio.test", full_name: "Maria Garcia", company_name: "Design Studio Co", bio: "Award-winning design agency creating beautiful digital experiences." }
]

employers = employers_data.map do |data|
  User.find_or_create_by!(email: data[:email]) do |u|
    u.password = "password123"
    u.full_name = data[:full_name]
    u.company_name = data[:company_name]
    u.bio = data[:bio]
    u.role = :employer
  end
end
puts "  Created #{employers.size} employers"

# Seekers
seekers_data = [
  { email: "alice@example.test", full_name: "Alice Williams", bio: "Full-stack developer with 5 years of experience in Ruby and JavaScript." },
  { email: "charlie@example.test", full_name: "Charlie Brown", bio: "UX designer passionate about accessible and inclusive design." },
  { email: "diana@example.test", full_name: "Diana Chen", bio: "Marketing specialist with expertise in growth hacking and SEO." },
  { email: "evan@example.test", full_name: "Evan Martinez", bio: "Data scientist skilled in Python, R, and machine learning." },
  { email: "fiona@example.test", full_name: "Fiona O'Brien", bio: "Product manager with experience shipping B2B SaaS products." }
]

seekers = seekers_data.map do |data|
  User.find_or_create_by!(email: data[:email]) do |u|
    u.password = "password123"
    u.full_name = data[:full_name]
    u.bio = data[:bio]
    u.role = :seeker
  end
end
puts "  Created #{seekers.size} seekers"

# Jobs
jobs_data = [
  { employer: employers[0], category: "Engineering", title: "Senior Rails Developer", location: "San Francisco, CA", salary_min: 150000, salary_max: 200000, job_type: :full_time, status: :published,
    body: "<h3>About the Role</h3><p>We're looking for a Senior Rails Developer to join our platform team. You'll build and maintain our core API, work with microservices, and mentor junior developers.</p><h3>Requirements</h3><ul><li>5+ years Ruby on Rails experience</li><li>Strong PostgreSQL/database skills</li><li>Experience with Hotwire (Turbo + Stimulus)</li><li>Familiarity with CI/CD pipelines</li></ul><h3>Benefits</h3><ul><li>Competitive salary + equity</li><li>Remote-friendly</li><li>Health, dental, vision insurance</li><li>Unlimited PTO</li></ul>" },
  { employer: employers[0], category: "Engineering", title: "Junior Backend Developer", location: "San Francisco, CA", salary_min: 80000, salary_max: 110000, job_type: :full_time, status: :published,
    body: "<h3>About the Role</h3><p>Great opportunity for a junior developer to learn and grow. You'll work alongside senior engineers on our backend systems.</p><h3>Requirements</h3><ul><li>CS degree or bootcamp graduate</li><li>Familiarity with Ruby or Python</li><li>Eager to learn and grow</li></ul>" },
  { employer: employers[0], category: "DevOps", title: "DevOps Engineer", location: "Remote", salary_min: 130000, salary_max: 170000, job_type: :remote, status: :published,
    body: "<h3>About the Role</h3><p>Manage our cloud infrastructure on AWS, implement CI/CD pipelines, and ensure 99.99% uptime for our services.</p><h3>Requirements</h3><ul><li>3+ years DevOps experience</li><li>AWS/GCP expertise</li><li>Docker and Kubernetes</li><li>Terraform experience</li></ul>" },
  { employer: employers[0], category: "Product", title: "Technical Product Manager", location: "San Francisco, CA", salary_min: 140000, salary_max: 180000, job_type: :full_time, status: :published,
    body: "<p>Lead product strategy for our developer tools platform. Work closely with engineering and design to deliver features that developers love.</p>" },
  { employer: employers[0], category: "Engineering", title: "Mobile Developer (iOS)", location: "San Francisco, CA", salary_min: 140000, salary_max: 190000, job_type: :full_time, status: :draft,
    body: "<p>Build our iOS app from scratch using Swift and SwiftUI.</p>" },
  { employer: employers[1], category: "Engineering", title: "Full Stack Developer", location: "New York, NY", salary_min: 120000, salary_max: 160000, job_type: :full_time, status: :published,
    body: "<h3>About StartupXYZ</h3><p>We're a Series B fintech startup revolutionizing how businesses handle payments. Join our engineering team and build the future of finance.</p><h3>What You'll Do</h3><ul><li>Build and maintain our Next.js + Rails stack</li><li>Implement payment processing features</li><li>Write clean, well-tested code</li></ul>" },
  { employer: employers[1], category: "Marketing", title: "Growth Marketing Manager", location: "New York, NY", salary_min: 90000, salary_max: 130000, job_type: :full_time, status: :published,
    body: "<p>Drive user acquisition and retention through data-driven marketing campaigns. Own our growth funnel from awareness to conversion.</p>" },
  { employer: employers[1], category: "Sales", title: "Enterprise Account Executive", location: "New York, NY", salary_min: 100000, salary_max: 150000, job_type: :full_time, status: :published,
    body: "<p>Close enterprise deals and build relationships with Fortune 500 companies. Base salary + uncapped commission.</p>" },
  { employer: employers[1], category: "Finance", title: "Financial Analyst", location: "New York, NY", salary_min: 85000, salary_max: 120000, job_type: :full_time, status: :published,
    body: "<p>Support our CFO with financial modeling, budgeting, and investor reporting.</p>" },
  { employer: employers[1], category: "Data Science", title: "Data Analyst", location: "Remote", salary_min: 95000, salary_max: 130000, job_type: :remote, status: :published,
    body: "<p>Analyze product usage data, build dashboards, and provide insights to drive product decisions.</p>" },
  { employer: employers[1], category: "Engineering", title: "QA Engineer", location: "New York, NY", salary_min: 90000, salary_max: 125000, job_type: :contract, status: :closed,
    body: "<p>Contract position for automated testing of our payment platform.</p>" },
  { employer: employers[2], category: "Design", title: "Senior Product Designer", location: "Los Angeles, CA", salary_min: 130000, salary_max: 170000, job_type: :full_time, status: :published,
    body: "<h3>The Opportunity</h3><p>Join our award-winning design team and shape the visual identity of products used by millions. We believe in design-driven development.</p><h3>What We're Looking For</h3><ul><li>5+ years product design experience</li><li>Strong portfolio with web and mobile work</li><li>Proficiency in Figma</li><li>Experience with design systems</li></ul>" },
  { employer: employers[2], category: "Design", title: "UX Researcher", location: "Los Angeles, CA", salary_min: 100000, salary_max: 140000, job_type: :full_time, status: :published,
    body: "<p>Conduct user research to inform design decisions. Run usability tests, interviews, and surveys.</p>" },
  { employer: employers[2], category: "Design", title: "Motion Designer", location: "Remote", salary_min: 80000, salary_max: 120000, job_type: :remote, status: :published,
    body: "<p>Create beautiful animations and micro-interactions for web and mobile products.</p>" },
  { employer: employers[2], category: "Marketing", title: "Content Strategist", location: "Los Angeles, CA", salary_min: 75000, salary_max: 105000, job_type: :part_time, status: :published,
    body: "<p>Develop content strategy for our clients' digital platforms. Part-time position with flexible hours.</p>" },
  { employer: employers[2], category: "Operations", title: "Project Coordinator", location: "Los Angeles, CA", salary_min: 60000, salary_max: 80000, job_type: :full_time, status: :published,
    body: "<p>Coordinate client projects, manage timelines, and ensure smooth delivery of design work.</p>" }
]

created_jobs = jobs_data.map do |data|
  cat = Category.find_by!(name: data[:category])
  job = Job.find_or_create_by!(title: data[:title], user: data[:employer]) do |j|
    j.category = cat
    j.location = data[:location]
    j.salary_min = data[:salary_min]
    j.salary_max = data[:salary_max]
    j.job_type = data[:job_type]
    j.status = data[:status]
    j.expires_at = rand(15..60).days.from_now.to_date if data[:status] == :published
  end
  job.update!(body: data[:body]) if job.body.blank?
  job
end
puts "  Created #{created_jobs.size} jobs"

# Applications
published_jobs = Job.published.to_a
applications_data = [
  { seeker: seekers[0], job: published_jobs[0], status: :interview, cover_letter: "I have 6 years of Rails experience and have built multiple production applications. I'm excited about the opportunity to mentor junior developers." },
  { seeker: seekers[0], job: published_jobs[1], status: :applied, cover_letter: "I'd love to help build your payment processing features." },
  { seeker: seekers[1], job: published_jobs[5], status: :reviewed, cover_letter: "My portfolio showcases 3 years of product design work for SaaS products." },
  { seeker: seekers[1], job: published_jobs[6], status: :applied, cover_letter: "I'm passionate about user research and have conducted over 50 usability studies." },
  { seeker: seekers[2], job: published_jobs[3], status: :offer, cover_letter: "I've driven 3x growth at my current company through SEO and content marketing." },
  { seeker: seekers[2], job: published_jobs[4], status: :applied, cover_letter: "Enterprise sales is my forte. I've closed deals worth $2M+ annually." },
  { seeker: seekers[3], job: published_jobs[2], status: :interview, cover_letter: "I bring strong skills in Kubernetes, Terraform, and AWS. Ready to tackle infrastructure challenges." },
  { seeker: seekers[3], job: published_jobs[8], status: :applied, cover_letter: "Data analysis is my passion. I'm proficient in SQL, Python, and Tableau." },
  { seeker: seekers[4], job: published_jobs[0], status: :reviewed, cover_letter: "As a PM with 4 years of experience, I understand the developer mindset and can bridge engineering and business." },
  { seeker: seekers[4], job: published_jobs[9], status: :rejected, cover_letter: "I'd love to coordinate projects at your design studio." }
]

applications_data.each do |data|
  next if data[:job].nil?

  JobApplication.find_or_create_by!(user: data[:seeker], job: data[:job]) do |a|
    a.status = data[:status]
    a.cover_letter = data[:cover_letter]
  end
end
puts "  Created #{JobApplication.count} applications"

# Saved Jobs
seekers.each do |seeker|
  published_jobs.sample(rand(1..3)).each do |job|
    SavedJob.find_or_create_by!(user: seeker, job: job)
  end
end
puts "  Created #{SavedJob.count} saved jobs"

puts "\nSeed complete!"
puts "  Admin:     admin@jobboard.test / password123"
puts "  Employer:  jane@techcorp.test / password123"
puts "  Seeker:    alice@example.test / password123"
