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
    'APROVED',
    'DENIED'
  ]

  validates :start_date, :end_date, :cat_id, :status, presence: true
  validates :status, inclusion: STATUS
  # validate :request_does_not_overlap


  def overlapping_requests
    CatRentalRequest.find_by_sql([<<-SQL, start_date: start_date, end_date: end_date, id: id])
      SELECT
        *
      FROM
        cat_rental_requests
      WHERE
        NOT (end_date < :start_date OR start_date > :end_date) AND
        id != :id
    SQL
  end

  def request_does_not_overlap
    errors.add("") if overlapping_aproved_requests?
  end

  def other_aproved_rental_requests
    cat.rental_requests.select!(&:aproved?).delete(self)
  end

  def conflicts?(another_request)
    !(another_request.start_date > end_date ||
      another_request.end_date < start_date)
  end

  def overlapping_aproved_requests?(other_rental_requests)
    other_aproved_rental_requests.any?(&:conflicts?)
  end

  def aproved?
    status == 'APROVED'
  end

end
