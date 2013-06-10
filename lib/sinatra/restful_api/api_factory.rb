class ApiFactory
  attr_reader :model_name, :settings

  def initialize(model_name, settings)
    @model_name = model_name
    @settings   = settings
  end

  def build_restful_api!
    adapter.tap do |adapter|
      response_parser_setup && response_caching_setup
    end
  end

  private

  def adapter
    @adaper ||= settings.restful_api_adapter.new(model_class)
  end

  def model_class
    model_name.to_s.singularize.classify.constantize
  end

  def response_parser_setup(parser=::RestfulApi::Json)
    parser.include_root_in_json = setting_or_default(:include_root_in_json, false)
    adapter.extend parser
  end

  def response_caching_setup(cache=::RestfulApi::Caching)
    cache.cache_store = setting_or_default(:restful_api_cache_store, nil)
    adapter.extend cache
  end

  def setting_or_default(setting, default)
    settings.respond_to?(setting) ? settings.send(setting) : default
  end

end
