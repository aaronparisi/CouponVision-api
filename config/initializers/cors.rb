Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins 'http://localhost:8080', 
      'http://localhost:5000',
      'http://localhost:8000',
      'https://coupon-vision.web.app',
      'http://coupon-vision.web.app',
      'https://www.coupon-vision.web.app',
      'http://www.coupon-vision.web.app',
      'https://coupons.aaronparisi.dev',
      'http://coupons.aaronparisi.dev',
      'https://www.coupons.aaronparisi.dev',
      'http://www.coupons.aaronparisi.dev'

    resource '*',
      headers: :any,
      methods: [:get, :post, :put, :patch, :delete, :options, :head],
      credentials: true,
      exposedHeaders: ["Set-Cookie"]
  end
end