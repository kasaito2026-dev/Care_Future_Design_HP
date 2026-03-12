# Rack::Attack - Rate limiting and request throttling
class Rack::Attack
  # Throttle general requests by IP (300 requests per 5 minutes)
  throttle("req/ip", limit: 300, period: 5.minutes) do |req|
    req.ip unless req.path.start_with?("/assets")
  end

  # Throttle form submissions more aggressively (5 per minute)
  throttle("contact/ip", limit: 5, period: 1.minute) do |req|
    req.ip if req.path == "/contact" && req.post?
  end

  throttle("join/ip", limit: 5, period: 1.minute) do |req|
    req.ip if req.path == "/join" && req.post?
  end

  # Throttle admin login attempts (10 per minute)
  throttle("admin/ip", limit: 10, period: 1.minute) do |req|
    req.ip if req.path.start_with?("/admin")
  end

  # Block suspicious requests
  blocklist("block-bad-agents") do |req|
    # Block requests with empty User-Agent
    req.user_agent.blank? && req.path != "/up"
  end
end
