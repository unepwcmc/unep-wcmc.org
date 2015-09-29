require 'spec_helper'

describe SubmissionsController do
  describe "#new" do
    before do
      @form = create(:form)
      create(:field, form_id: @form.id, type: "TextField")
      create(:field, form_id: @form.id, type: "FileField")
    end

    it "builds new form submission" do
      get :new, form_id: @form.id
      assigns(:submission).should_not be_blank
    end

    it "sets all submission's fields" do
      get :new, form_id: @form.id
      assigns(:submission).field_submissions.size.should == 2
    end

    it "should render 404 when form not found" do
      create('404')
      get :new, form_id: 'nonsense'
      expect(response.status).to eq(404)
    end
  end

  describe "#edit" do
    before do
      @form = create(:form)
      create(:field, form_id: @form.id, type: "TextField")
      create(:field, form_id: @form.id, type: "FileField")
      @submission = Submission.build_for_form(@form)
      @submission.email = "some@example.com"
      @submission.content = OpenStruct.new(
        uk_working_ability: true,
        last_salary: 0,
        benefits: 'n/a',
        interview_availability: 'yes',
        notice_period: '1 month'
      )
      @submission.save
    end

    it "assigns form and submission" do
      get :edit, form_id: @form.id, id: @submission.slug
      assigns(:submission).should == @submission
      assigns(:form).should == @form
    end
  end
end
