require 'spec_helper'

describe Programme do
  let(:programme) { create(:programme) }
  let(:subprogramme) { create(:programme, parent_programme_id: programme.id) }

  it 'should build valid factory' do
    programme.should be_valid
  end

  describe 'validates parent programme' do
    it 'succeeds when parent programme is not a subprogramme' do
      build(:programme, parent_programme_id: programme.id).should be_valid
    end

    it 'fails when parent programme is a subprogramme' do
      build(:programme, parent_programme_id: subprogramme.id).should have(1).error_on(:parent_programme_id)
    end
  end

  describe '#has_employees?' do
    context 'no employees present' do
      it { programme.has_employees?.should == false }
    end

    context 'employees present' do
      let!(:subprogramme_with_employee) { create(:programme, :with_employee, parent_programme_id: programme.id) }

      it { programme.has_employees?.should == true }
    end
  end
end
