require 'rails_helper'

describe Api::V1::ProductsController do
  let (:user) { FactoryBot.create :user }
  let(:valid_attributes) {{
    name: "Samsung TV",
    description: "32' LCD Samsung TV, good condition",
    user_id: user.id,
    cost: 1_000
  }}

  let(:invalid_attributes) {{
    name: "Samsung TV"
  }}

  let(:valid_session) { {} }

  before(:each) do
    auth_headers = user.create_new_auth_token
    request.headers.merge!(auth_headers)
  end

  describe "GET #index" do
    it "returns a success response" do
      product = Product.create! valid_attributes
      get :index, params: {}, session: valid_session
      expect(response).to be_success
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      product = Product.create! valid_attributes
      get :show, params: {id: product.to_param}, session: valid_session
      expect(response).to be_success
    end
  end

  describe "POST #create" do
    context "with valid params" do
      let(:create_params) {{
        name: "Samsung TV",
        description: "32' LCD Samsung TV, good condition",
        cost: 1_000
      }}
      it "creates a new Product" do
        expect {
          post :create, params: {product: create_params}, session: valid_session
        }.to change(Product, :count).by(1)
        product_id = JSON.parse(response.body)["data"]["id"]
        product = Product.find(product_id)
        expect(product.user_id).to eq(user.id)
      end

      it "renders a JSON response with the new product" do

        post :create, params: {product: create_params}, session: valid_session
        expect(response).to have_http_status(:created)
        expect(response.content_type).to eq('application/json')
        expect(response.location).to eq(v1_product_url(Product.last))
      end
    end

    context "with invalid params" do
      it "renders a JSON response with errors for the new product" do

        post :create, params: {product: invalid_attributes}, session: valid_session
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json')
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        {name: "new name"}
      }

      it "updates the requested product" do
        product = Product.create! valid_attributes
        put :update, params: {id: product.to_param, product: new_attributes}, session: valid_session
        product.reload
        expect(product.name).to eq("new name")
      end

      it "renders a JSON response with the product" do
        product = Product.create! valid_attributes

        put :update, params: {id: product.to_param, product: valid_attributes}, session: valid_session
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq('application/json')
      end
    end

    context "with invalid params" do
      it "renders a JSON response with errors for the product" do
        product = Product.create! valid_attributes

        put :update, params: {id: product.to_param, product: {cost: "test"}}, session: valid_session
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json')
      end
    end

    context "forbidden when a different user tries to update" do
      it "renders forbidden response" do
        invalid_user = FactoryBot.create :user
        product = Product.create! valid_attributes.merge(user_id: invalid_user.id)

        put :update, params: {id: product.to_param, product: invalid_attributes}, session: valid_session
        expect(response).to have_http_status(:forbidden)
        expect(response.content_type).to eq('application/json')
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested product" do
      product = Product.create! valid_attributes
      expect {
        delete :destroy, params: {id: product.to_param}, session: valid_session
      }.to change(Product, :count).by(-1)
    end

    context "forbidden when a different user tries to delete" do
      it "renders forbidden response" do
        invalid_user = FactoryBot.create :user
        product = Product.create! valid_attributes.merge(user_id: invalid_user.id)

        delete :destroy, params: {id: product.to_param}, session: valid_session
        expect(response).to have_http_status(:forbidden)
        expect(response.content_type).to eq('application/json')
      end
    end
  end

end