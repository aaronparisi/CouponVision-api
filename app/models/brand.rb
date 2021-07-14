# == Schema Information
#
# Table name: brands
#
#  id               :bigint           not null, primary key
#  max_coupon_value :decimal(, )
#  min_coupon_value :decimal(, )
#  name             :string
#  num_products     :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
class Brand < ApplicationRecord
  has_many :products
  has_many :coupons, through: :products, source: :coupons

  has_many :grocer_brands
  has_many :grocers, through: :grocer_brands, source: :grocer

  def full_of_products?
    return self.products.count >= self.num_products
  end

  def self.all_full?
    return self.all.all? { |brand| brand.full_of_products? }
  end
  # limiting seeding products by each brand's num_products might have made these
  # obsolete

  def self.savings_by_brand
    data = self
      .joins(products: [coupons: [:store]])
      .pluck(
        "brands.name as brand_name",
        "coupons.activation_date as activation_date",
        "coupons.expiration_date as expiration_date",
        "coupons.savings as savings",
        "stores.state as state"
      )
    
    flattened = {}
    children = []

    data.each do |row|
      if flattened[row[0]]
        if flattened[row[0]][row[4]]
          flattened[row[0]][row[4]].push(
            {
              state: row[4],
              activation_date: row[1], 
              expiration_date: row[2],
              savings: row[3]
            }
          )
        else
          flattened[row[0]][row[4]] = [
            { 
              state: row[4],
              activation_date: row[1], 
              expiration_date: row[2],
              savings: row[3]
            }
          ]
        end
      else
        flattened[row[0]] = {}
        flattened[row[0]][row[4]] = [
          {
            state: row[4],
            activation_date: row[1], 
            expiration_date: row[2],
            savings: row[3]
          }
        ]
      end
    end

    flattened.each do |brand_name, coupons|
      children.push({ 
        name: brand_name, 
        children: coupons.map { |state_name, coupons| { name: state_name, children: coupons }}
      })
    end
    
    return {
      name: "brands",
      children: children
    }
  end

  def self.calcTierIdx(savings, numTiers, tiers)
    (1..numTiers).each do |idx|
      return idx if (savings >= tiers[idx][:tierMin] && savings < tiers[idx][:tierMax])
    end

    return numTiers
  end

  def self.savings_tiers_by_brand
    ## construct tiers
    tiers = {}
    savings = Coupon.pluck("min(coupons.savings) as minSavings", "max(coupons.savings) as maxSavings")
    minSavings = savings[0][0].floor(-1).to_i
    maxSavings = savings[0][1].ceil(-1).to_i
    numTiers = 5  ## adjustable?
    tierRange = (maxSavings - minSavings) / numTiers  ## the "length" of a single tier

    (1..numTiers).each do |idx|
      tiers[idx] = {
        tierMin: minSavings + (tierRange * idx),
        tierMax: minSavings + (tierRange * (idx+1))
      }
    end

    ## query data
    data = self
      .joins(products: [coupons: [:store]])
      .pluck(
        "brands.name as brand_name",
        "coupons.activation_date as activation_date",
        "coupons.expiration_date as expiration_date",
        "coupons.savings as savings",
      )
    
    flattened = {}
    children = []

    data.each do |row|
      ## calculate "savings tier"
      tierIdx = calcTierIdx(row[3], numTiers, tiers)

      if flattened[row[0]]  ## if brand object already exists
        if flattened[row[0]][tierIdx]  ## if "savings tier" already exists
          flattened[row[0]][tierIdx].push(
            {
              tier_idx: tierIdx,
              activation_date: row[1], 
              expiration_date: row[2],
              savings: row[3]
            }
          )
        else
          flattened[row[0]][tierIdx] = [
            { 
              tier_idx: tierIdx,
              activation_date: row[1],
              expiration_date: row[2],
              savings: row[3]
            }
          ]
        end
      else
        flattened[row[0]] = {}
        flattened[row[0]][tierIdx] = [
          {
            tierIdx: tierIdx,
            activation_date: row[1], 
            expiration_date: row[2],
            savings: row[3]
          }
        ]
      end
    end

    flattened.each do |brand_name, coupons|
      children.push({ 
        name: brand_name, 
        children: coupons.map { |tier_idx, coupons| { name: tier_idx, children: coupons }}
      })
    end
    
    return {
      tiers: tiers,
      treeData: {
        name: "brands",
        children: children
      }
    }
  end
end