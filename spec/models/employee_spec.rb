require 'rails_helper'

RSpec.describe Employee, type: :model do
  describe 'attributes' do
    let!(:employees) { [Employee.create(name: 'Juan'), Employee.create(name: 'Pedro'), Employee.create(name: 'Diego')] }
    it 'uses match array to match a scope' do
      expect(Employee.all).to match_array(employees)
    end
  end
  context 'before creation' do
    let!(:employee) { Employee.create(name: 'Juan') }
    let!(:blank_employee) { Employee.create(name: '') }
    let!(:nil_employee) { Employee.create }
    it 'cannot be a name duplicate' do
      expect { Employee.create!(name: 'Juan') }.to raise_error(ActiveRecord::RecordNotUnique)
    end
    it 'name to be a non empty string' do
      expect(blank_employee.errors.errors).not_to be_empty
    end
    it 'name not to be nil' do
      expect(nil_employee.errors.errors).not_to be_empty
    end
  end
end
