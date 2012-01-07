class Lawyer < User
  # validates :payment_email, :bar_ids, :practice_areas, :presence =>true
  # validates :payment_email, :presence => true

  has_many :conversations
  has_many :bar_memberships
  has_many :states, :through => :bar_memberships
  has_many :expert_areas
  has_many :practice_areas, :through => :expert_areas
  has_one :homepage_image, :dependent => :destroy

  accepts_nested_attributes_for :bar_memberships, :reject_if => proc { |attributes| attributes['state_id'].blank? }

  scope :approved_lawyers, lambda { where("user_type = '#{User::LAWYER_TYPE}' and is_approved is true").order("is_online desc") }

  def self.approved_lawyers_states
    states = []

    approved_lawyers.each do |lawyer|
      states << lawyer.states
    end

   return states[0]
  end

  # returns currently online lawyer user
  def self.online
   self.where('is_online is true' )
  end

  def total_earning
    sum = 0.0
    self.conversations.map{|con| sum += con.lawyer_earning }
    sum
  end

  # in seconds
  def total_session_duration
    total_duration = 0
    self.conversations.map{|con| total_duration += con.duration }
    total_duration
  end

  # in seconds
  def total_paid_duration
    total_duration = 0
    self.conversations.map{|con| total_duration += con.billed_time }
    total_duration
  end

  def parent_practice_area_string
    ppa = self.practice_areas.parent_practice_areas.map{|p| p.name}
    ppa.join(',')
  end
end

