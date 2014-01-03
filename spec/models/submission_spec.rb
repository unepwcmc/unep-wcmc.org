require 'spec_helper'

describe Submission do

  before do
    @form = create(:form)
    create(:field, form_id: @form.id, type: "TextField")
    create(:field, form_id: @form.id, type: "FileField")
  end

  describe "#build_for_form" do
    before do
      @submission = described_class.build_for_form(@form)
    end

    it "assigns correct form id" do
      @submission.form_id.should == @form.id
    end

    it "builds fields with correct types" do
      binding.pry
      @submission.field_submissions.size.should == 2
      @submission.field_submissions[0].type.should == "TextFieldSubmission"
      @submission.field_submissions[1].type.should == "FileFieldSubmission"
    end
  end
end
