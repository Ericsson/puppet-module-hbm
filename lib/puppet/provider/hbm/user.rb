$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', '..', '..'))

require 'puppet/provider/hbm'

Puppet::Type.type(:hbm).provide(:user) do
  include Puppet::Provider::Hbm

  defaultfor kernel: :Linux

  has_feature :members

  commands hbm: '/usr/sbin/hbm'

  def exists?
    res_exists
  end

  def create
    res_create
  end

  def destroy
    res_destroy
  end
end
