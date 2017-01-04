HERE = File.absolute_path(File.dirname(__FILE__))

cache_name = (ENV['DOCKER_TAG'] || 'native').tr(':', '/')
base_dir "#{HERE}/.local/#{cache_name}"

# Cache gets its own prefix for easier caching in Travis
cache_dir "#{HERE}/.local/cache/#{cache_name}"
git_cache_dir "#{HERE}/.local/cache/git_cache_dir/#{cache_name}"

# We only build 64 bits Windows packages
windows_arch :x64
