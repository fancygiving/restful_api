RESTful API
===========

```ruby
require 'sinatra'
require 'sinatra/restful_api'
require 'datamapper'

class Person
  include DataMapper::Resource

  property :name, String
end

restful_api :people
```