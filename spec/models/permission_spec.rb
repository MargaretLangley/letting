require 'spec_helper'
require_relative '../../app/models/permission'

RSpec::Matchers.define :allow? do |*args|
  match do |permission|
    expect(permission.allow?(*args)).to be true
  end
end

describe Permission, :type => :model do

  context 'as guest' do

    subject { Permission.new(nil) }

    it('session#new') { is_expected.to allow?('sessions', 'new') }
    it('session#create') { is_expected.to allow?('sessions', 'create') }
    it('session#destroy') { is_expected.to allow?('sessions', 'destroy') }

    it('properties#index') { is_expected.not_to allow?('properties', 'index') }
    it('properties#create') { is_expected.not_to allow?('properties', 'create') }
    it('properties#edit') { is_expected.not_to allow?('properties', 'edit') }
    it('properties#update') { is_expected.not_to allow?('properties', 'update') }
    it('properties#destroy') { is_expected.not_to allow?('properties', 'destroy') }

    it('clients#index') { is_expected.not_to allow?('clients', 'index') }
    it('clients#create') { is_expected.not_to allow?('clients', 'create') }
    it('clients#edit') { is_expected.not_to allow?('clients', 'edit') }
    it('clients#update') { is_expected.not_to allow?('clients', 'update') }
    it('clients#destroy') { is_expected.not_to allow?('clients', 'destroy') }

    it('users#index') { is_expected.not_to allow?('users', 'index') }
    it('users#create') { is_expected.not_to allow?('users', 'create') }
    it('users#edit') { is_expected.not_to allow?('users', 'edit') }
    it('users#update') { is_expected.not_to allow?('users', 'update') }
    it('users#destroy') { is_expected.not_to allow?('users', 'destroy') }

  end

  context 'as user' do

    subject { Permission.new(User.create! user_attributes) }

    it('session#new')      { is_expected.to allow?('sessions', 'new') }
    it('session#create')   { is_expected.to allow?('sessions', 'create') }
    it('session#destroy')  { is_expected.to allow?('sessions', 'destroy') }

    it('properties#index')   { is_expected.to allow?('properties', 'index') }
    it('properties#create')  { is_expected.to allow?('properties', 'create') }
    it('properties#edit')    { is_expected.to allow?('properties', 'edit') }
    it('properties#update')  { is_expected.to allow?('properties', 'update') }
    it('properties#destroy') { is_expected.to allow?('properties', 'destroy') }

    it('clients#index') { is_expected.to allow?('clients', 'index') }
    it('clients#create') { is_expected.to allow?('clients', 'create') }
    it('clients#edit') { is_expected.to allow?('clients', 'edit') }
    it('clients#update') { is_expected.to allow?('clients', 'update') }
    it('clients#destroy') { is_expected.to allow?('clients', 'destroy') }

  end

  context 'admin' do
    subject { Permission.new(User.create! user_attributes admin: false) }

    it('users#index') { is_expected.not_to allow?('users', 'index') }
    it('users#create') { is_expected.not_to allow?('users', 'create') }
    it('users#edit') { is_expected.not_to allow?('users', 'edit') }
    it('users#update') { is_expected.not_to allow?('users', 'update') }
    it('users#destroy') { is_expected.not_to allow?('users', 'destroy') }

  end

  context 'admin' do
    subject { Permission.new(User.create! user_attributes admin: true) }

    it('session#destroy')  { is_expected.to allow?('sessions', 'destroy') }
    it('clients#destroy') { is_expected.to allow?('clients', 'destroy') }
    it('properties#destroy') { is_expected.to allow?('properties', 'destroy') }

    it('users#index') { is_expected.to allow?('users', 'index') }
    it('users#create') { is_expected.to allow?('users', 'create') }
    it('users#edit') { is_expected.to allow?('users', 'edit') }
    it('users#update') { is_expected.to allow?('users', 'update') }
    it('users#destroy') { is_expected.to allow?('users', 'destroy') }

  end
end
