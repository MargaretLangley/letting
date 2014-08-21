require 'rails_helper'
require_relative '../../../lib/import/patch_model'
# rubocop: disable Style/Documentation

module DB
  describe 'PatchModel', :import do
    let(:patchee) { client_new human_ref: 800 }

    context 'changed?' do
      it 'true when names different' do
        patch_model = PatchModel.new client_new
        patchee = client_new
        patchee.entities.first.name = 'Name Changed'
        expect(patch_model.changed?(patchee)).to be true
      end

      it 'false when names match' do
        patch_model = PatchModel.new client_new
        patchee = client_new
        expect(patch_model.changed?(patchee)).to be false
      end

      it 'expected error message' do
        expect($stdout).to receive(:puts).with(/Cannot match/)
        patch_model = PatchModel.new client_new
        patchee = client_new
        patchee.entities.first.name = 'Name Changed'
        patch_model.changed?(patchee)
      end
    end
  end
end
