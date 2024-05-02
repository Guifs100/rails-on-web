class PoliciesController < ApplicationController
  def new
  end

  def create
    policy = policy_params

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
end
