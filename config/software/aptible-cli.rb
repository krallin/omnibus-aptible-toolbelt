name 'aptible-cli'
default_version 'v0.6.8'

license 'MIT'
license_file 'LICENSE.md'

source git: 'https://github.com/aptible/aptible-cli.git'

dependency 'ruby'
dependency 'rubygems'
dependency 'appbundler'
dependency 'bundler'

build do
  env = with_standard_compiler_flags(with_embedded_path)

  # This installs dependencies, and creates a Gemfile.lock for use by
  # appbundler later.
  bundle 'install --without development test', env: env

  # Now, we still need to actually install aptible-cli in the embedded package
  gem 'build aptible-cli.gemspec', env: env
  gem 'install ./aptible-cli-*.gem --local --no-ri --no-rdoc', env: env

  # Finally, create the `aptible-cli` binstub.
  command "appbundler . '#{install_dir}/bin' aptible-cli", env: env
end
