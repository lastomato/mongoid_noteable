class News
  include Mongoid::Document
  include Mongoid::Timestamps

  field :subject, :type => String
  field :action, :type => String
  field :object, :type => String

  belongs_to :noteable, :polymorphic => true

  scope :desc_created_at, desc(:created_at)
  scope :by_field, lambda { |name, value| where(name.to_sym => value).desc_created_at }
  scope :by_time, lambda { |t| where(:created_at.gt => Time.now - t).desc_created_at }
  scope :before, lambda { |t| where(:created_at.lt => Time.now - t).desc_created_at }
end