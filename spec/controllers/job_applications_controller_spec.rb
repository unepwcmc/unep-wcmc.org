require 'spec_helper'

describe JobApplicationsController do

  before :all do
    puts "before all"
    @form = create(:form)
  end

  before :each do
    @user = create(:user)
    sign_in @user
  end

  describe "GET #index" do
    it "populates and array of forms (job applications)" do
      get :index
      assigns(:forms).should eq([@form])
    end

    it "renders the :index view" do
      get :index
      response.should render_template :index
    end
  end

  describe "GET #show" do
    it "assigns the requested form to @form" do
      get :show, id: @form
      assigns(:form).should eq(@form)
    end

    it "renders the #show view" do
      get :show, id: @form
      response.should render_template :show
    end
  end

  describe "GET #download_all_applications_zip" do
    it "renders the #download_all_applications_zip view" do
      form = create(:form)
      get :download_all_applications_zip, id: @form
      controller.should_receive(:send_file)
    end
  end
end
