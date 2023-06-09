# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  has_many :courses
  has_many :comments, dependent: :destroy
  has_many :scores, dependent: :destroy
  has_many :carts, dependent: :destroy

  pay_customer stripe_atributes: :stripe_atributes

  validates :name, presence: true

  validates :name, format: { with: /\A[a-zA-ZáéíóúÁÉÍÓÚüÜñÑ\-\. ]+\Z/,
    message: "El nombre no tiene formato valido" }
  enum role: { customer: 0, admin: 1 }

  def stripe_atributes(pay_customer)
    {
      address: {
        city: pay_customer.owner.city,
        country: pay_customer.owner.country
      },
      metadata: {
        pay_customer_id: pay_customer.id,
        user_id: id
      }
    }
  end

  def bought_courses
    Course.joins(:carts, :cart_items).where(carts: { user: self, status: 1 }).group(:id)
  end
end
