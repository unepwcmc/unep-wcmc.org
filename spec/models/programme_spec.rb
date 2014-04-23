require 'spec_helper'

describe Programme do
  let(:programme) { create(:programme) }
  let(:subprogramme) { create(:programme, :parent_programme_id => programme.id)}

  it 'should build valid factory' do
    programme.should be_valid
  end

  describe 'validates parent programme' do
    it 'succeeds when parent programme is not a subprogramme' do
      build(:programme, :parent_programme_id => programme.id).should be_valid
    end

    it 'fails when parent programme is a subprogramme' do
      build(:programme, :parent_programme_id => subprogramme.id).should have(1).error_on(:parent_programme_id)
    end
  end
end
