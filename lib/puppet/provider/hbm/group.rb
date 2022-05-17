$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', '..', '..'))

require 'puppet/provider/hbm'

Puppet::Type.type(:hbm).provide(:group) do
  include Puppet::Provider::Hbm

  commands :hbm => '/usr/sbin/hbm'

  def exists?
    result = findkey(resource[:provider], resource[:name])
    return result
  end

  def create
    execute([command(:hbm), 'group', 'add', @resource[:name]])
  end

  def destroy
    execute([command(:hbm), 'group', 'rm', @resource[:name]])
  end
end
