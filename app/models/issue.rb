class Issue < ActiveRecord::Base
  attr_accessible :content, :status, :title, :user_id, :assignee_id, :relevant_gist

  belongs_to :user

  belongs_to :assignee, :class_name => "User", :foreign_key => :assignee_id

  STATUS_MAP = {
    :closed => 0,
    :waiting_room => 1,                # part of the waiting_room queue
    :fellow_student => 2,              # part of the fellow_student queue
    :instructor_normal => 3,           # part of the instructor queue
    :instructor_urgent => 4            # part of the instructor queue
  }

  def current_status
    Issue.status.key(self.status).to_s 
  end

  def self.status
    STATUS_MAP
  end

  def self.closed
    Issue.where(:status => STATUS_MAP[:closed])
  end

  def self.not_closed
    issues = Issue.arel_table # http://asciicasts.com/episodes/215-advanced-queries-in-rails-3
    Issue.where(issues[:status].not_eq(STATUS_MAP[:closed]))
  end

  def is_closed?
    self.status == STATUS_MAP[:closed]
  end

  def self.waiting_room(user_id)
    Issue.where(:status => STATUS_MAP[:waiting_room], :user_id => user_id)
  end

  def is_waiting_room?
    self.status == STATUS_MAP[:waiting_room]
  end

  def self.fellow_student
    Issue.not_assigned.where(:status => STATUS_MAP[:fellow_student])
  end

  def is_fellow_student?
    self.status == STATUS_MAP[:fellow_student]
  end

  def self.instructor_normal
    Issue.not_assigned.where(:status => STATUS_MAP[:instructor_normal])
  end

  def is_instructor_normal?
    self.status == STATUS_MAP[:instructor_normal]
  end

  def self.instructor_urgent
    Issue.not_assigned.where(:status => STATUS_MAP[:instructor_urgent])
  end

  def is_instructor_urgent?
    self.status == STATUS_MAP[:instructor_urgent]
  end

  def self.timebased_status
    Issue.not_closed.each do |issue|
      case
      when issue.created_at < Time.now-40.minutes 
        issue.status = STATUS_MAP[:instructor_urgent]
        issue.save
      when issue.created_at < Time.now-20.minutes
        issue.status = STATUS_MAP[:instructor_normal]
        issue.save 
      when issue.created_at < Time.now-5.minutes
        issue.status = STATUS_MAP[:fellow_student]
        issue.save
      end       
    end
  end

  def from_current_user
    self.user_id == @current_user.id    
  end  

  def assigned_to
    User.find_by_id(self.assignee_id).name
  end

  def self.assigned
    Issue.not_closed.where("assignee_id >= ?", 0)
  end

  def self.not_assigned
    Issue.not_closed.where("assignee_id IS NULL")
  end

  def self.wait_time_total
    (Issue.wait_time_open_in_seconds + Issue.wait_time_closed_in_seconds)/60
  end

  def self.average_wait_time_total
    Issue.wait_time_total/(Issue.total_open_issues + Issue.total_closed_issues)
  end

  def self.wait_time_open_in_seconds
    Issue.not_closed.inject(0) do |time, issue|
      time + (Time.now - issue.created_at) 
    end
  end

  def self.wait_time_closed_in_seconds
    Issue.closed.inject(0) do |time, issue|
      time + (issue.updated_at - issue.created_at) 
    end
  end

  def self.total_open_issues
    Issue.not_closed.size
  end

  def self.total_closed_issues
    Issue.closed.size
  end

  def self.average_wait_time_open
    (Issue.wait_time_open_in_seconds/60)/Issue.total_open_issues
  end

  def self.average_wait_time_closed
    (Issue.wait_time_closed_in_seconds/60)/Issue.total_closed_issues
  end

end