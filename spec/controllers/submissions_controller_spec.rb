require 'spec_helper'

describe SubmissionsController do
  before do
    @form = create(:form)
    create(:field, form_id: @form.id, type: "TextField")
    create(:field, form_id: @form.id, type: "FileField")
  end

  describe "#new" do
    it "builds new form submission" do
      get :new, form_id: @form.id
      assigns(:submission).should_not be_blank
    end

    it "sets all submission's fields" do
      get :new, form_id: @form.id
      assigns(:submission).field_submissions.size.should == 2
    end
  end
end
