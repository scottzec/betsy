class Merchant < ApplicationRecord
  has_many :products
  has_many :orderitems, through: :products

  def self.build_from_github(auth_hash)
    merchant = Merchant.new
    merchant.uid = auth_hash[:uid]
    merchant.provider = "github"
    # merchant can change name later
    merchant.username = auth_hash["info"]["name"]
    merchant.email = auth_hash["info"]["email"]

    return merchant
  end
end
