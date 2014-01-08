require 'spec_helper'

describe Submission do

  before do
    @form = create(:form)
    create(:field, form_id: @form.id, type: "TextField")
    create(:field, form_id: @form.id, type: "FileField")
  end

  it "assigns random and unique slug on creation" do
    f1 = create(:submission, form_id: @form.id)
    f2 = create(:submission, form_id: @form.id)
    f1.slug.should be_present
    f2.slug.should be_present
    f1.slug.should_not == f2.slug
  end

  describe "#build_for_form" do
    before do
      @submission = described_class.build_for_form(@form)
    end

    it "assigns correct form id" do
      @submission.form_id.should == @form.id
    end

    it "builds fields with correct types" do
      @submission.field_submissions.size.should == 2
      @submission.field_submissions[0].type.should == "TextFieldSubmission"
      @submission.field_submissions[1].type.should == "FileFieldSubmission"
    end
  end
end
