require 'spec_helper'

describe EmploymentsBuilder do

  let(:params) {
    [ {id: "5", role: "Bottle cleaner"},
      {id: "6", role: "Captain obvious"},
      {id: "7", role: "The Very Important Guy"} ]
  }

  let(:project) {
    double("project")
  }

  let(:programme) {
    double("programme")
  }

  before do
    Employment.create(employee_id: 5, project_id: 5, role: "Some guy")
    Employment.create(employee_id: 5, project_id: 5, role: "Some other guy")
    Employment.create(employee_id: 10, project_id: 6, role: "Some guy from different project")
    Employment.create(programme_id: 5, employee_id: 5, role: "Some programme employee")
  end

  describe "#save" do
    it "removes all other employments for given project" do
      project.stub(:id) { 5 }
      builder = described_class.new(project: project, employments: [])
      expect{ builder.save }.to change{ Employment.count }.by(-2)
    end

    it "removes all employments for given programme" do
      programme.stub(:id) { 5 }
      builder = described_class.new(programme: programme, employments: [])
      expect{ builder.save }.to change{ Employment.count }.by(-1)
    end

    it "saves new records for each employment for programme" do
      programme.stub(:id) { 5 }
      builder = described_class.new(programme: programme, employments: params)
      expect{ builder.save }.to change{ Employment.count }.by(2)
    end

    it "saves new records for each employment for project" do
      project.stub(:id) { 5 }
      builder = described_class.new(project: project, employments: params)
      expect{ builder.save }.to change{ Employment.count }.by(1)
    end
  end
end

