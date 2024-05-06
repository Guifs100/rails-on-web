class PoliciesController < ApplicationController
  include Requester

  def new
  end

  def create
    policy = policy_params
    headers = {
      'Content-Type' => 'application/json',
      'Authorization' => "Bearer #{encode}"
    }
    body = body_builder(policy_params).to_json
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
                }
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
