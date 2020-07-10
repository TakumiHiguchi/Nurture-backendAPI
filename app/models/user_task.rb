class UserTask < ApplicationRecord
    validates :title, length: { in: 1..150 }
    validates :content, length: { in: 0..100000 }
end
