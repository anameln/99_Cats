# == Schema Information
#
# Table name: cats
#
#  id          :integer          not null, primary key
#  name        :string(255)      not null
#  sex         :string(255)      not null
#  description :text
#  birth_date  :date
#  color       :string(255)      not null
#

class Cat < ActiveRecord::Base
  has_many :rental_requests, dependent: :destroy,
    class_name: "CatRentalRequest"

  COLORS = [
              "Brown",
              "Black",
              "White",
              "Green",
              "Red",
              "Blue"
            ]

  SEX = [ "M", "F" ]

  validates :name, :sex, :color, presence: true
  validates :sex, inclusion: { in: SEX }
  validates :color, inclusion: { in: COLORS }

  def self.colors
    COLORS
  end

  def age
    return "NA" if birth_date.nil?
    (Time.now.year - birth_date.to_time.year)
  end

  def pending_requests
    rental_requests.where("status = 'PENDING'")
  end

  def approved_requests
    rental_requests.where("status = 'APPROVED'")
  end

  def denied_requests
    rental_requests.where("status = 'DENIED'")
  end

end
