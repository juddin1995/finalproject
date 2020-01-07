class User < ActiveRecord::Base
    validates :firstname, :lastname, :username, :password, presence: true
    validates :email, :username, uniqueness: true
    validates :password, length: {minimum: 5, max: 8}

    has_many :posts,dependent: :destroy
end

class Post < ActiveRecord::Base
    validates :body, length: {maximum: 255}
    belongs_to :user
end