Facter.add(:docker_version) do
  setcode do
    if Facter::Util::Resolution.which('docker')
      docker_version = Facter::Core::Execution.execute('docker version -f {{.Client.Version}} 2> /dev/null')
      docker_version.match(%r{^([\d\.]+)}).to_a[1]
    end
  end
end
