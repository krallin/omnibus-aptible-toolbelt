# This monkey patch works around a bug in Omnibus that causes git versioning as
# well as license file creation to fail (returning the wrong version for the
# former and finding no licenses for the latter) in case sources aren't cleaned
# when building (which can easily happen if we're building from cache and the
# sources haven't needed cleaning because they weren't built).
#
# This fixes the issue by always cleaning software sources, regardless of
# whether they'll be built or restored from cache (which also means we clean
# them twice when actually building... but that's the lesser of two evils).

module CleanSoftwareExtension
  def build_me
    fetcher.clean
    super
  end
end

::Omnibus::Software.class_eval do
  prepend CleanSoftwareExtension
end
