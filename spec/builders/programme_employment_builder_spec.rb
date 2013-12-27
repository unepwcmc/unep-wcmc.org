require 'spec_helper'

describe ProgrammeEmploymentBuilder do

  let(:params) {
    {id: "5", role: "Bottle cleaner"}
  }

  let(:employee) {
    double("employee")
  }

  before do
    Employment.create(employee_id: 5, programme_id: 5, role: "Some guy")
  end

  describe "#save" do
    it "updates role" do
      employee.stub(:id) { 5 }
      builder = described_class.new(employee: employee, employment: params)
      builder.save
      Employment.for_programmes.for_employee(employee).first.role.should == "Bottle cleaner"
    end

    it "removes old employment" do
      employee.stub(:id) { 5 }
      builder = described_class.new(employee: employee, employment: params)
      builder.save
      Employment.for_programmes.for_employee(employee).count.should == 1
    end
  end
end

