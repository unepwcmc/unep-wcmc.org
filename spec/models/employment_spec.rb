require 'spec_helper'

describe Employment do
  let(:project) { double("project") }
  let(:employee) { double("employee") }
  let(:programme) { double("programme") }

  before do
    create(:employment, project_id: 1, employee_id: 3)
    create(:employment, project_id: 2, employee_id: 1)
    create(:employment, project_id: 1, employee_id: 2)
    create(:employment, project_id: 2, employee_id: 2)
    create(:employment, programme_id: 4, employee_id: 7)
    create(:employment, programme_id: 5, employee_id: 7)
    project.stub(:id) { 1 }
    employee.stub(:id) { 1 }
    programme.stub(:id) { 4 }
  end


  describe "#for_project" do
    it "returns all employments for a project with given id" do
      described_class.for_project(project).count.should == 2
    end
  end

  describe "#for_employee" do
    it "returns all employments for an employee with given id" do
      described_class.for_employee(employee).count.should == 1
    end
  end

  describe "#destroy_for_project" do
    it "destroys all employments for a project with given id" do
      expect{described_class.destroy_for_project(project)}.to change{described_class.count}.by(-2)
    end
  end

  describe "#destroy_for_employee" do
    it "destroys all employments for an employee with given id" do
      expect{described_class.destroy_for_employee(employee)}.to change{described_class.count}.by(-1)
    end
  end

  describe "#destroy_for_programme" do
    it "destroys all employments for a programme with given id" do
      expect{described_class.destroy_for_programme(programme)}.to change{described_class.count}.by(-1)
    end
  end
end
