class Slug

  class << self
    def [](slug)
      redis.hget(hash, slug)
    end

    def []=(slug, id)
      if old = self[slug]
        redis.srem(set(old), slug)
      end
      redis.hset(hash, slug, id)
      redis.sadd(set(id), slug)
    end

    def destroy(id)
      redis.smembers(set(id)).each { |slug| redis.hdel(hash, slug) }
      redis.del(set(id))
    end

    private 

    def redis
      $redis
    end

    def hash
      "location"
    end


    def set(id)
      "location_slugs_#{id}"
    end
  end
end