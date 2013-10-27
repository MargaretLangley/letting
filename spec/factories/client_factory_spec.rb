require 'spec_helper'

describe 'Client Factory' do

  let(:client) { client_new }
  it('is valid') { expect(client).to be_valid }

  it('no id') { expect(client.id).to eq nil }
  it('has default human_ref') { expect(client.human_ref).to eq 8008 }
  it('overridable human_ref') do
    client = client_new human_ref: 3003
    expect(client.human_ref).to eq 3003
  end

  it('has entity') { expect(client.entities[0].name).to eq 'Grace' }
  it('has address') { expect(client.address.town).to eq 'Birmingham' }
  it('overrides address') do
    client = client_create! address_attributes: { town: 'York' }
    expect(client.address.town).to eq 'York'
  end

end
