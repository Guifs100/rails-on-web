module Requester
  def self.send_request(headers, body, url)
    response = Net::HTTP.post(url, body, headers)
  rescue
    nil
  end
end
