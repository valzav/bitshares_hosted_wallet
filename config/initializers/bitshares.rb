require Rails.root.join("lib/BitShares/bitshares_api.rb").to_s
require Rails.root.join("lib/BitShares/calls_sanitizer.rb").to_s

BitShares::API.init(5691, 'user', 'pass')
