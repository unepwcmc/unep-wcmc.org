require 'spec_helper'

describe ProjectEmploymentsBuilder do

  let(:params) {
    [ {id: "5", role: "Bottle cleaner"},
      {id: "6", role: "Captain obvious"},
      {id: "7", role: "The Very Important Guy"} ]
  }

  let(:project) {
    double("project")
  }

  before do
    Employment.create(employee_id: 5, project_id: 5, role: "Some guy")
    Employment.create(employee_id: 5, project_id: 5, role: "Some other guy")
    Employment.create(employee_id: 10, project_id: 6, role: "Some guy from different project")
  end

  describe "#save" do
    it "removes all other employments for given project" do
      project.stub(:id) { 5 }
      builder = described_class.new(project: project, employments: [])
      expect{ builder.save }.to change{ Employment.count }.by(-2)
    end

    it "saves new records for each employment for project" do
      project.stub(:id) { 5 }
      builder = described_class.new(project: project, employments: params)
      expect{ builder.save }.to change{ Employment.count }.by(1)
    end
  end
end

