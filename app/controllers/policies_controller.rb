class PoliciesController < ApplicationController
  include Requester

  def new
  end

  def create
    session = Stripe::Checkout::Session.create(
      payment_method_types: ['card'],
      line_items: [{
        price: 'price_1PDsdHFAZsZguLCRZjU1gwDt',
        quantity: 1,
      }],
      mode: 'payment',
      success_url:  success_charges_url,
      cancel_url: cancel_charges_url
    )

    policy = policy_params
    policy[:payment_id] = session.id
    policy[:payment_link] = session.url

    headers = {
      'Content-Type' => 'application/json',
      'Authorization' => "Bearer #{encode}"
    }
    body = body_builder(policy).to_json
    url = URI("http://web:3003/graphql")

    response = Requester.send_request(headers, body, url)
    responsed_body = JSON.parse(response.body, symbolize_names: true)

    if responsed_body[:data][:createPolicy][:result] == 'OK'
      flash[:alert] = "Policy created successfully!!"
      redirect_to root_path
    end
  rescue
    #TODO melhorar o rescue
    flash.now[:notice] = "Error"
  end

  def policy_params
    params.require(:policy).permit(
      :insured_name,
      :insured_cpf,
      :date_issue,
      :policy_expiration,
      :license_plate,
      :brand,
      :model,
      :year
    )
  end

  def body_builder(policy)
    {
      query: "mutation {
        createPolicy(
        input: {
            policy: {
                dateIssue: \"#{policy[:date_issue]}\",
                policyExpiration: \"#{policy[:policy_expiration]}\",
                insured: {
                    name: \"#{policy[:insured_name]}\",
                    cpf: \"#{policy[:insured_cpf]}\",
                },
                vehicle: {
                    licensePlate: \"#{policy[:license_plate]}\",
                    brand: \"#{policy[:brand]}\",
                    model: \"#{policy[:model]}\",
                    year: \"#{policy[:year]}\"
                },
                charge: {
                  paymentId: \"#{policy[:payment_id]}\",
                  paymentLink: \"#{policy[:payment_link]}\",
                },
            }
        }
         ) { result }
      }"
    }
  end

  #TODO fazer usando variáveis
  # {
  #   query: "
  #     mutation createPolicy(
  #       $dateIssue: String!
  #       $policyExpiration: String!
  #       $name: String!
  #       $cpf: String!
  #       $licensaPlate: String!
  #       $brand: String!
  #       $model: String!
  #       $year: String!
  #     )
  #     {
  #       createPolicy (
  #         input: {
  #           policy: {
  #             dateIssue: $dateIssue,
  #             policyExpiration: $policyExpiration
  #             insured: {
  #               name: $name,
  #               cpf: $cpf
  #             },
  #             vehicle: {
  #               licensaPlate: $licensaPlate,
  #               brand: $brand,
  #               model: $model,
  #               year: $year
  #             }
  #           }
  #         }
  #       )
  #     }
  #   ",
  #   variables: {
  #     dateIssue: policy[:date_issue],
  #     policyExpiration: policy[:policy_expiration],
  #     name: policy[:insured_name],
  #     cpf: policy[:insured_cpf],
  #     licensaPlate: policy[:license_plate],
  #     brand: policy[:brand],
  #     model: policy[:model],
  #     year: policy[:year]
  #   }
  # }
end
