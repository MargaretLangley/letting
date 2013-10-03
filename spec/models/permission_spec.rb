require 'spec_helper'
require_relative '../../app/models/permission'

RSpec::Matchers.define :allow? do |*args|
  match do |permission|
    expect(permission.allow?(*args)).to be_true
  end
end

describe Permission do

  context 'as guest' do

    subject { Permission.new(nil) }

    it('session#new') { should allow?('sessions', 'new') }
    it('session#create') { should allow?('sessions', 'create') }
    it('session#destroy') { should allow?('sessions', 'destroy') }

    it('properties#index') { should_not allow?('properties', 'index') }
    it('properties#create') { should_not allow?('properties', 'create') }
    it('properties#edit') { should_not allow?('properties', 'edit') }
    it('properties#update') { should_not allow?('properties', 'update') }
    it('properties#destroy') { should_not allow?('properties', 'destroy') }

    it('clients#index') { should_not allow?('clients', 'index') }
    it('clients#create') { should_not allow?('clients', 'create') }
    it('clients#edit') { should_not allow?('clients', 'edit') }
    it('clients#update') { should_not allow?('clients', 'update') }
    it('clients#destroy') { should_not allow?('clients', 'destroy') }

    it('users#index') { should_not allow?('users', 'index') }
    it('users#create') { should_not allow?('users', 'create') }
    it('users#edit') { should_not allow?('users', 'edit') }
    it('users#update') { should_not allow?('users', 'update') }
    it('users#destroy') { should_not allow?('users', 'destroy') }

  end

  context 'as user' do

    subject { Permission.new(User.create! user_attributes) }

    it('session#new')      { should allow?('sessions', 'new') }
    it('session#create')   { should allow?('sessions', 'create') }
    it('session#destroy')  { should allow?('sessions', 'destroy') }

    it('properties#index')   { should allow?('properties', 'index') }
    it('properties#create')  { should allow?('properties', 'create') }
    it('properties#edit')    { should allow?('properties', 'edit') }
    it('properties#update')  { should allow?('properties', 'update') }
    it('properties#destroy') { should allow?('properties', 'destroy') }

    it('clients#index') { should allow?('clients', 'index') }
    it('clients#create') { should allow?('clients', 'create') }
    it('clients#edit') { should allow?('clients', 'edit') }
    it('clients#update') { should allow?('clients', 'update') }
    it('clients#destroy') { should allow?('clients', 'destroy') }

  end

  context 'admin' do
    subject { Permission.new(User.create! user_attributes admin: false) }

    it('users#index') { should_not allow?('users', 'index') }
    it('users#create') { should_not allow?('users', 'create') }
    it('users#edit') { should_not allow?('users', 'edit') }
    it('users#update') { should_not allow?('users', 'update') }
    it('users#destroy') { should_not allow?('users', 'destroy') }

  end

  context 'admin' do
    subject { Permission.new(User.create! user_attributes admin: true) }

    it('session#destroy')  { should allow?('sessions', 'destroy') }
    it('clients#destroy') { should allow?('clients', 'destroy') }
    it('properties#destroy') { should allow?('properties', 'destroy') }

    it('users#index') { should allow?('users', 'index') }
    it('users#create') { should allow?('users', 'create') }
    it('users#edit') { should allow?('users', 'edit') }
    it('users#update') { should allow?('users', 'update') }
    it('users#destroy') { should allow?('users', 'destroy') }

  end
end
