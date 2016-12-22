require 'spec_helper'

testcases = {
  'default' => {
    params: { },
    expect: {
      install_dir: '/opt/easyrsa',
      pkiroot: '/etc/easyrsa',
      key_size: 2048,
    }
  },
  'customized' => {
    params: {
      key_size: 4096,
    },
    expect: {
      install_dir: '/opt/easyrsa',
      pkiroot: '/etc/easyrsa',
      key_size: 4096,
    }
  },
}

describe 'easyrsa::dh' do

  testcases.each do |profile, values|

      let(:pre_condition) { [
        'contain easyrsa',
        'contain easyrsa::params',
        'easyrsa::pki { "default": }',
        'easyrsa::pki { "customized": }',
      ] }

    context "testing #{profile}" do
      let(:title) { profile }
      let(:params) { values[:params] }

      it do
        should contain_exec("build-dh-#{title}")
          .with_command("#{values[:expect][:install_dir]}/easyrsa --pki-dir='#{values[:expect][:pkiroot]}/#{title}' --keysize=#{values[:expect][:key_size]} --batch gen-dh")
          .with_cwd("#{values[:expect][:install_dir]}")
          .with_creates("#{values[:expect][:pkiroot]}/#{title}/dh.pem")
          .with_provider('shell')
          .with_timeout('0')
          .with_logoutput(true)
      end
    end
  end #testcases.each
end #describe