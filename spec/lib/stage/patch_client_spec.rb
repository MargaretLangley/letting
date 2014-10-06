require_relative '../../../lib/stage/patch_client'

describe PatchClient, :stage do
  def row human_ref: 10, value: 4
    { human_ref: human_ref, value: value }
  end

  it 'returns unmatched data unmolested' do
    input = [row(human_ref: 10, value: 4)]
    patch = PatchClient.new patch: [row(human_ref: 20, value: 8)]
    expect(patch.cleanse originals: input).to eq [row(human_ref: 10, value: 4)]
  end

  it 'returns patch data when id match' do
    input = [row(human_ref: 10, value: 4)]
    patch = PatchClient.new patch: [row(human_ref: 10, value: 8)]
    expect(patch.cleanse originals: input).to eq [row(human_ref: 10, value: 8)]
  end
end
