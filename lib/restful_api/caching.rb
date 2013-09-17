module RestfulApi
  module Caching
    def self.cache_store=(boolean=false)
      @cache_store = boolean
    end

    def self.cache_store
      @cache_store
    end

    def read_instance(instance, options={})
      if cache_results?(options) && cache_key = read_instance_cache_key(instance, options)
        cache.fetch(cache_key) { super }
      else
        super
      end
    end

    private

    def cache_results?(options={})
      cache_option = options[:cache].nil? ? true : options[:cache]
      cache_option && cache.present?
    end

    def read_instance_cache_key(instance, options)
      instance && instance.cache_key("read_instance/#{options}")
    end

    def cache
      @cache ||= Caching.cache_store
    end
  end
end