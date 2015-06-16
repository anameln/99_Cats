# == Schema Information
#
# Table name: cat_rental_requests
#
#  id         :integer          not null, primary key
#  cat_id     :integer          not null
#  start_date :datetime         not null
#  end_date   :datetime         not null
#  status     :string(255)      default("PENDING")
#  created_at :datetime
#  updated_at :datetime
#

class CatRentalRequest < ActiveRecord::Base

  belongs_to :cat

  STATUS = [
    'PENDING',
    'APPROVED',
    'DENIED'
  ]

  validates :start_date, :end_date, :cat_id, :status, presence: true
  validates :status, inclusion: STATUS
  validate :request_does_not_overlap
  after_initialize :default_status

  def request_does_not_overlap
    errors.add(:time, "overlaps") unless approved? && approved_overlapping_requests.empty?
  end

  def overlapping_requests
    CatRentalRequest.where([<<-SQL, start_date: start_date, end_date: end_date, id: id])
      NOT (end_date < :start_date OR start_date > :end_date) AND id != :id
    SQL
  end

  def approved_overlapping_requests
    overlapping_requests.where("status = ?", "APPROVED")
  end

  def not_approved_overlapping_requests
    overlapping_requests.where("status = ?", "PENDING")
  end

  def default_status
    self.status ||= "PENDING"
  end

  def approve!
    ActiveRecord::Base.transaction do
      self.status = 'APPROVED'
      self.save!
      not_approved_overlapping_requests.each(&:deny!)
    end
  end

  def approved?
    status == "APPROVED"
  end

  def deny!
    self.status = "DENIED"
    self.save
  end

end
