Facter.add(:hbm_version) do
  setcode do
    if Facter::Util::Resolution.which('hbm')
      hbm_version = Facter::Core::Execution.execute("hbm version | grep -E '^HBM|^Version' | awk '{ print $2 }' 2> /dev/null")
      hbm_version.match(%r{^([\d\.]+)}).to_a[1]
    end
  end
end
