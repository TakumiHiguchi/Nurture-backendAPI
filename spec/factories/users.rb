FactoryBot.define do
  factory :user do
    base_worker = BaseWorker.new
    key = base_worker.get_key

    key { key }
    session { Digest::SHA256.hexdigest(key) }
    maxAge { Time.now.to_i + 3600 }
  end
end
