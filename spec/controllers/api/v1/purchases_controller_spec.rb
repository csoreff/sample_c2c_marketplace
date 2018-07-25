require 'rails_helper'

describe Api::V1::PurchasesController do
  let (:user) { FactoryBot.create :user }
  let (:seller) { FactoryBot.create :user }
  let (:product) { FactoryBot.create :product, user: seller }
  let(:valid_attributes) {{
    product_id: product.id,
    user_id: seller.id,
    amount: 100
  }}

  let(:invalid_attributes) {{
    product_id: 123
  }}

  let(:valid_session) { {} }


  before(:each) do
    auth_headers = user.create_new_auth_token
    request.headers.merge!(auth_headers)
  end

  describe "GET #index" do
    it "returns a success response" do
      purchase = Purchase.create! valid_attributes
      get :index, params: {}, session: valid_session
      expect(response).to be_success
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      purchase = Purchase.create! valid_attributes
      get :show, params: {id: purchase.to_param}, session: valid_session
      expect(response).to be_success
    end
  end

  describe "POST #create" do
    context "with valid params" do
      let(:create_params) {{
        product_id: product.id
      }}

      it "creates a new Purchase" do
        expect {
          post :create, params: {purchase: create_params}, session: valid_session
        }.to change(Purchase, :count).by(1)
        purchase_id = JSON.parse(response.body)["data"]["id"]
        purchase = Purchase.find(purchase_id)
        expect(purchase.user_id).to eq(user.id)
        expect(purchase.amount).to eq(product.cost)

        original_user_points = user.points
        original_seller_points = seller.points
        expect(user.reload.points).to eq(original_user_points - product.cost)
        expect(seller.reload.points).to eq(original_seller_points + product.cost)
      end

      it "renders a JSON response with the new purchase" do
        post :create, params: {purchase: create_params}, session: valid_session
        expect(response).to have_http_status(:created)
        expect(response.content_type).to eq('application/json')
        expect(response.location).to eq(v1_purchase_url(Purchase.last))
      end
    end

    context "with invalid params" do
      it "renders a JSON response with errors for the new purchase" do
        post :create, params: {purchase: invalid_attributes}, session: valid_session
        expect(response).to have_http_status(:not_found)
        expect(response.content_type).to eq('application/json')
      end
    end
  end
end