require 'spec_helper'
require_relative '../../../lib/import/patch_model'

module DB
  describe 'PatchModel' do
    let(:patchee) { client_new human_ref: 800 }

    context 'changed?' do
      it 'true when names different' do
        patch_model = PatchModel.new client_new
        patchee = client_new
        patchee.entities.first.name = 'Name Changed'
        expect(patch_model.changed?(patchee)).to be_true
      end

      it 'false when names match' do
        patch_model = PatchModel.new client_new
        patchee = client_new
        expect(patch_model.changed?(patchee)).to be_false
      end

      it 'expected error message' do
        $stdout.should_receive(:puts).with(/Cannot match/)
        patch_model = PatchModel.new client_new
        patchee = client_new
        patchee.entities.first.name = 'Name Changed'
        patch_model.changed?(patchee)
      end
    end
  end
end