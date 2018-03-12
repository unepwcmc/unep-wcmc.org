require 'spec_helper'

describe ApplicationsController do

  before :each do
    @user = create(:user)
  end

  describe "GET #index" do
    it "populates and array of forms (job applications)" do
      sign_in @user
      form = create(:form)
      get :index
      assigns(:forms).should eq([form])
    end

    it "renders the :index view" do
      sign_in @user
      get :index
      response.should render_template :index
    end
  end

  describe "GET #show" do
    it "assigns the requested form to @form" do
      sign_in @user
      form = create(:form)
      get :show, id: form
      assigns(:form).should eq(form)
    end

    it "renders the #show view" do
      sign_in @user
      get :show, id: create(:form)
      response.should render_template :show
    end
  end
end
