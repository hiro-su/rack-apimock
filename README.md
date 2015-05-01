# Rack::APIMock

Simple Rack Middleware for API Mock.

The origin of an idea is https://github.com/CyberAgent/node-easymock

## Usage

```
$ rackup sample/config.ru
```

## Differentiating GET/POST/PUT/DELETE
If you want to use advanced serving features like GET/POST/PUT/DELETE or templates in json, provide files like in the example below:

```
GET / => index_get.json
GET /items/1 => items/1_get.json.erb
POST /items/1 => items/1_post.json.erb
...
```

##  Response Headers

```
<% @status = 200 %>
<% @headers = { "Content-Type" => "application/json" }
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/rack-apimock/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
