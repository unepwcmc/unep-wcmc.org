require "spec_helper"

describe Comfy::Cms::PageObserver do
  before do
    @project = create(:featured_project)
    @employee = create(:employee)
    create(:employment, project_id: @project.id, employee_id: @employee.id)
    create(:employment, project_id: 7, employee_id: @employee.id)
  end

  it "removes dependent employments when removing project" do
    expect{@project.destroy}.to change{Employment.count}.by(-1)
  end

  it "removes dependent employments when removing employees" do
    expect{@employee.destroy}.to change{Employment.count}.by(-2)
  end
end
