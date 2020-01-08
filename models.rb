class User < ActiveRecord::Base
    validates :first_name, :last_name, :password, presence: true
    validates :email, uniqueness: true
    validates :password, length: {minimum: 5, max: 8}

    has_many :posts,dependent: :destroy
end

class Post < ActiveRecord::Base
    validates :body, length: {maximum: 255}
    belongs_to :user
end