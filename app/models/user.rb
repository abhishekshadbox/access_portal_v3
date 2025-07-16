class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # belongs_to :organization, optional: true

  # enum role: { member: 0, manager: 1, admin: 2 }

  validates :date_of_birth, presence: true
  validate :validate_age_for_consent

  def age
    return unless date_of_birth
    ((Time.zone.now - date_of_birth.to_time) / 1.year.seconds).floor
  end

  def age_group
    case age
    when 0..12 then 'under_13'
    when 13..17 then 'teen'
    else 'adult'
    end
  end

  private

  def validate_age_for_consent
    if age && age < 13 && !parental_consent
      errors.add(:base, "Parental consent required for users under 13")
    end
  end
end
