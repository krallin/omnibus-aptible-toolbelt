cache_name = (ENV['DOCKER_TAG'] || 'native').tr(':', '/')
base_dir "./.local/#{cache_name}"

# Cache gets its own prefix for easier caching in Travis
cache_dir "./.local/cache/#{cache_name}"
git_cache_dir "./.local/cache/git_cache_dir/#{cache_name}"
