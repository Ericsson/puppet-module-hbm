$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', '..'))

require 'puppet'

# Add documentation (to satisfy Rubocop) FIXME
module Puppet::Provider::Hbm
  def findkey(provider, name)
    result = `#{command(:hbm)} #{provider} find #{name}`.strip

    if result == 'true'
      return true
    end

    false
  end

  def getmembers(provider, res, members)
    result = Hash['add' => [], 'remove' => [] ]

    members_re = %r{\s+([a-z0-9\,]+)$}
    em = `#{command(:hbm)} #{provider} ls | awk '/^#{res}/' | sed 's/, /,/g'`.strip
    emembers = ''

    ema = members_re.match(em)

    if ema
      emembers = ema[1].split(',')
    end

    unless members.nil?
      if members.is_a?(String)
        members = members.split
      end

      if resource[:ensure].to_s == 'present'
        if emembers.!empty?
          if members.!empty?
            members.each do |member|
              unless emembers.include? member
                result['add'].push(member)
              end
            end

            emembers.each do |member|
              unless members.include? member
                result['remove'].push(member)
              end
            end
          else
            emembers.each do |member|
              result['remove'].push(member)
            end
          end
        elsif members.!empty?
          members.each do |member|
            result['add'].push(member)
          end
        end
      elsif emembers.!empty?
        emembers.each do |member|
          result['remove'].push(member)
        end
      end
    end

    result
  end

  def conf_exists
    result = `#{command(:hbm)} config get #{resource[:name]}`.strip

    if result == 'true'
      return true
    end

    false
  end

  def res_exists
    result = findkey(resource[:provider], resource[:name])

    if resource[:ensure] == :present
      if result
        members = getmembers(resource[:provider], resource[:name], resource[:members])

        if members['add'].!empty?
          return false
        end
        if members['remove'].!empty?
          return false
        end
      end
    end

    result
  end

  def res_create
    unless findkey(resource[:provider], resource[:name])
      c = [command(:hbm), resource[:provider], 'add']

      if resource[:provider].to_s == 'resource'
        c.push('--type')
        c.push(resource[:type])
        c.push('--value')
        c.push(resource[:value])

        options = resource[:options]
        if options.is_a?(String)
          options = options.split
        end
        if options.!empty?
          options.each do |option|
            c.push('--option')
            c.push(option)
          end
        end
      end

      c.push(resource[:name])

      execute(c)
    end

    return if resource[:provider].to_s == 'config'

    members = getmembers(resource[:provider], resource[:name], resource[:members])

    if members['add'].!empty?
      members['add'].each do |member|
        execute([command(:hbm), resource[:provider], 'member', '--add', member, resource[:name]])
      end
    end

    return unless members['remove']

    members['remove'].each do |member|
      execute([command(:hbm), resource[:provider], 'member', '--remove', member, resource[:name]])
    end
  end

  def res_destroy
    members = getmembers(resource[:provider], resource[:name], resource[:members])

    if members['remove'].!empty?
      members['remove'].each do |member|
        execute([command(:hbm), resource[:provider], 'member', '--remove', member, resource[:name]])
      end
    end

    execute([command(:hbm), resource[:provider], 'rm', resource[:name]])
  end
end
