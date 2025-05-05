module RedisHelper
  def create_redis_cache(key, data)
   
   
    REDIS_CLIENT.set(key, JSON.dump(data), ex: 60) # Cache for 60 seconds
    puts "Cache created for key: #{key}"
  end

  def get_redis_cache(key)
    cached_data = REDIS_CLIENT.get(key)
    return nil if cached_data.blank?

    JSON.parse(cached_data)
  end
end