Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins 'http://localhost:8080', 
      'http://localhost:5000',
      'http://localhost:8000',
      'https://coupon-vision.web.app',
      'http://coupon-vision.web.app',
      'https://www.coupon-vision.web.app',
      'http://www.coupon-vision.web.app',
      'https://coupons.aaronparisidev.com',
      'http://coupons.aaronparisidev.com',
      'https://www.coupons.aaronparisidev.com',
      'http://www.coupons.aaronparisidev.com'

    resource '*',
      headers: :any,
      methods: [:get, :post, :put, :patch, :delete, :options, :head],
      credentials: true,
      exposedHeaders: ["Set-Cookie"]
  end
end