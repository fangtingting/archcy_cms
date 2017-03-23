# 教程网址：http://www.runoob.com/redis/redis-tutorial.html
# 操作redis,Redis不仅仅支持简单的key-value类型的数据，同时还提供list，set，zset，hash等数据结构的存储。
# value可以是 字符串(String), 哈希(Hash), 列表(list), 集合(sets) 和 有序集合(sorted sets)等类型
class Common::RedisClient
  def initialize(*args)
    @redis ||= Redis.new(:host => "price-redis", :port => 6379)
  end

  # set {key: value}
  def set(key,value)
    @redis.set key, value.to_json
  end

  # 获取value
  def get(key)
    value = @redis.get(key)
    value ? JSON.load(value) : nil
  end

  # 判断是否存在参数所指定的字段
  def exists(key)
    @redis.exists(key)
  end

  # 保存hash {key: {field: value}}
  def hash_set(key,field,value)
    value = value.to_json unless value.is_a?(String)
    @redis.hset(key, field, value)
  end

  # 获取value
  def hash_get(key,field)
    value = @redis.hget(key, field) 
    value ? JSON.load(value) : nil
  end

  # 判断是否存在参数所指定的字段
  def hexists(key, field)
    @redis.hexists(key,field)
  end

  # 队列推送
  def queue_push(key, value)
    @redis.rpush key, value.to_json
  end

  # 队列获取
  def queue_get(key)
    value = @redis.lpop key
    value ? JSON.parse(value) : nil
  end

  # 删除指定key
  def del(key)
    @redis.del(key)
  end



end