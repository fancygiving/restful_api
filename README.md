RESTful API
===========

```ruby
require 'sinatra'
require 'sinatra/restful_api'
require 'dm-core'

DataMapper.setup(:default, 'sqlite:///test.db')

class Person
  include DataMapper::Resource

  property :id,   Serial
  property :name, String
end

DataMapper.finalize

set :restful_api_adapter, RestfulApi::DataMapper

restful_api :people
```