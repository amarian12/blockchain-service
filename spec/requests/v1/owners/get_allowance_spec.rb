require "rails_helper"

RSpec.describe "Get allowance" do
  let(:profile_id) { rand(1..10) }
  let(:profile_type) { "Owner" }
  let!(:spender) { Eth::Key.new.address }
  let(:amount) { rand(100..1000) }
  let(:profile_params) { { root: true } }

  context "profile exist" do
    before do 
      WalletService.create(profile_id, profile_type, profile_params)
      TokenService.new(profile_id, profile_type).approve(spender, amount)
      get get_allowance_v1_owners_path, params: { profile_id: profile_id, spender: spender }
    end

    it "returns allowance" do
      expect(response.body).to eq(amount.to_s)
    end 

    it "returns status :ok" do
      expect(response).to have_http_status(:ok)
    end
  end

  context "profile does not exist" do
    before do
      get get_balance_v1_owners_path, params: { profile_id: profile_id }
    end

    it "returns status :not_found" do
      expect(response).to have_http_status(:not_found)
    end
  end 
end
