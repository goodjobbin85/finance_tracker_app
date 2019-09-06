class User < ApplicationRecord
    validates :name, :username, :email, :password, presence: true
    validates :username, uniqueness: true
    validates :password, :email, length: { minimum: 8 }
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    validates :email, length: { maximum: 100 }, 
            uniqueness: { case_sensitive: false },
            format: { with: VALID_EMAIL_REGEX }
            
    def self.search_by_email(email)
         where("email LIKE ?", "%#{email}%") 
         begin
            user = User.find_by(email: email)
            new(name: user.name, email: user.email, username: user.username)
         rescue Exception => e
            return nil
            
         end
    end
    
    def self.search_by_name(name)
        where("name LIKE ?", "%#{name}%")
        begin
            user = User.find_by(name: name)
            new(name: user.name, email: user.email, username: user.username)
        rescue Exception => e
            return nil
        end
    
    end
    
    def self.search_by_username(username)
        where("username LIKE ?", "%#{username}%")
        begin
            user = User.find_by(username: username)
            new(name: user.name, email: user.email, username: user.username)
        rescue Exception => e
            return nil
        end
    end
    
    def stock_added?(ticker)
        stock = Stock.find_by_ticker(ticker)
        return false unless stock
        user_stocks.where(stock_id: stock.id).exists?
    end
    
    def under_stock_limit?
        (user_stocks.count < 10)
    end
    
    def can_add_stock?(ticker)
        under_stock_limit? && !stock_added?(ticker)
    end
    
    has_many :friendships
    has_many :friends, through: :friendships
    has_many :user_stocks
    has_many :stocks, through: :user_stocks
    
    has_secure_password
end
