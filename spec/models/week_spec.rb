require 'rails_helper'

RSpec.describe Week, type: :model do
  describe 'attributes' do
    let!(:weeks) do
      [Week.create(number: 0o2, year: 2021), Week.create(number: 0o3, year: 2021), Week.create(number: 0o4, year: 2021)]
    end
    it 'uses match array to match a scope' do
      expect(Week.all).to match_array(weeks)
    end
    it 'must have a year and greater than 0' do
      expect(Week.all.map(&:year)).to all(be > 0)
    end
    it 'must have a number and greater than 0' do
      expect(Week.all.map(&:number)).to all(be > 0)
    end
  end
  context 'before creation' do
    let!(:week) { Week.create(number: 0o2, year: 2021) }
    it 'cannot be a number and year duplicate' do
      expect { Week.create!(number: 0o2, year: 2021) }.to raise_error(ActiveRecord::RecordNotUnique)
    end
  end
end
