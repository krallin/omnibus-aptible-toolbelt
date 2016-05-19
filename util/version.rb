::Omnibus::BuildVersion.class_eval do
  def semver_with_platform
    # This wraps the semver tag with a non-significant platform name. This helps
    # ensure packages for different platforms don't have names that collide
    # (and that their names can be differentiated!).
    platform = Omnibus::Ohai['platform']
    platform_version = Omnibus::Ohai['platform_version']
    "#{semver}~#{platform}.#{platform_version}"
  end
end
