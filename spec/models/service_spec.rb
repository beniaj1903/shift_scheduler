require 'rails_helper'

RSpec.describe Service, type: :model do
  describe 'attributes' do
    let!(:services) { [Service.create(name: 'Move SPA'), Service.create(name: 'Ben EIRL'), Service.create(name: 'NYC Gas CO')] }
    it 'uses match array to match a scope' do
      expect(Service.all).to match_array(services)
    end
  end
  context 'before creation' do
    let!(:service) { Service.create(name: 'Move SPA') }
    let!(:blank_service) { Service.create(name: '') }
    let!(:nil_service) { Service.create }
    it 'cannot be a name duplicate' do
      expect { Service.create!(name: 'Move SPA') }.to raise_error(ActiveRecord::RecordNotUnique)
    end
    it 'name to be a non empty string' do
      expect(blank_service.errors.errors).not_to be_empty
    end
    it 'name not to be nil' do
      expect(nil_service.errors.errors).not_to be_empty
    end
  end
end
