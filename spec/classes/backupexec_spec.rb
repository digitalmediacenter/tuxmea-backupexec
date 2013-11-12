require 'spec_helper'
require 'rspec-puppet'
require 'hiera'
require 'facter'

hiera_config = 'spec/fixtures/hiera/hiera.yaml'

describe 'backeupexec' do
    context "with hiera config on RedHat" do
        let(:hiera_config) { hiera_config }
        let (:facts) { {
            :osfamily => 'RedHat'
        } }
    end # fin context "with hiera config on Debian"
end # fin describe 'one'
