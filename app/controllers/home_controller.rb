class HomeController < ApplicationController
  def index
    required_login

    policies(request_graphql)
  end

  private

  attr_reader :policies

  def policies(response_body)
    @policies ||= response_body.dig(:data, :policies)
  rescue
    nil
  end

  def request_graphql
    url = URI("http://web:3003/graphql")
    headers = {
      'Content-Type' => 'application/json',
      'Authorization' => "Bearer #{encode}"
    }
    body = { query: body_builder }.to_json

    response = Net::HTTP.post(url, body, headers)
    responsed_body = JSON.parse(response.body, symbolize_names: true)
  rescue
    nil
  end

  def body_builder
    <<-GRAPHQL
      query {
        policies(limit: null) {
            id
            dateIssue
            policyExpiration
            insured {
                id
                name
                cpf
            }
            vehicle {
                id
                licensePlate
                year
                model
                brand
            }
        }
      }
    GRAPHQL
  end
end
