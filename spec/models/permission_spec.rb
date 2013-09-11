require "spec_helper"
require_relative '../../app/models/permission'

RSpec::Matchers.define :allow? do |*args|
  match do |permission|
    expect(permission.allow?(*args)).to be_true
  end
end

describe Permission do

  context "as guest" do

    subject { Permission.new(nil) }

    it('session#new') { should allow?("sessions", "new") }
    it('session#create') { should allow?("sessions", "create") }
    it('session#destroy') { should allow?("sessions", "destroy") }

    it('properties#index') { should_not allow?("properties", "index") }
    it('properties#create') { should_not allow?("properties", "create") }
    it('properties#edit') { should_not allow?("properties", "edit") }
    it('properties#update') { should_not allow?("properties", "update") }
    it('properties#destroy') { should_not allow?("properties", "destroy") }

    it('clients#update') { should_not allow?("clients", "index") }
    it('clients#update') { should_not allow?("clients", "create") }
    it('clients#update') { should_not allow?("clients", "edit") }
    it('clients#update') { should_not allow?("clients", "update") }
    it('clients#update') { should_not allow?("clients", "destroy") }

  end

  context "as user" do

    subject { Permission.new(User.create! user_attributes) }

    it('session#new')      { should allow?("sessions", "new") }
    it('session#create')   { should allow?("sessions", "create") }
    it('session#destroy')  { should allow?("sessions", "destroy") }

    it('properties#index')   { should allow?("properties", "index") }
    it('properties#create')  { should allow?("properties", "create") }
    it('properties#edit')    { should allow?("properties", "edit") }
    it('properties#update')  { should allow?("properties", "update") }
    it('properties#destroy') { should allow?("properties", "destroy") }

    it('clients#update') { should allow?("clients", "index") }
    it('clients#update') { should allow?("clients", "create") }
    it('clients#update') { should allow?("clients", "edit") }
    it('clients#update') { should allow?("clients", "update") }
    it('clients#update') { should allow?("clients", "destroy") }

  end
end