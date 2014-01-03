require 'spec_helper'

describe FormSubmissionsController do
  before do
    form = create(:form)
    create(:field, form_id: form.id, type: "TextField")
    create(:field, form_id: form.id, type: "FileField")
  end

  describe "#new" do
    it "builds new form submission" do
      get :new, vacancy_id: 1
      assigns(:submission).should_not be_blank
    end

    it "sets all submission's fields" do
      get :new, vacancy_id: 1
      assigns(:submission).field_submissions.size.should == 2
    end
  end
end
