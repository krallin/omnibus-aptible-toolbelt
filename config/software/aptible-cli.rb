name 'aptible-cli'
default_version 'v0.8.2'

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

  # Now, create an aptible-cli binstub
  command "appbundler . '#{install_dir}/embedded/bin' aptible-cli", env: env

  # And finally, create the entrypoint file. This unsets APPBUNDLER_ALLOW_RVM
  # to ensure that can't accidentally break the CLI, and puts all our binaries
  # on the PATH (this includes e.g. ssh).
  cli_entrypoint = "#{install_dir}/bin/aptible"
  cli_entrypoint = "#{cli_entrypoint}.bat" if windows?

  vars_to_clear = %w(
    APPBUNDLER_ALLOW_RVM BUNDLE_ORIG_PATH BUNDLE_ORIG_GEM_PATH BUNDLE_BIN_PATH
    BUNDLE_GEMFILE RUBY_ROOT RUBYOPT RUBY_ENGINE RUBY_VERSION RUBYLIB
  )

  block do
    File.open(cli_entrypoint, 'w') do |f|
      if windows?
        f.puts('@ECHO OFF')
        vars_to_clear.each { |var| f.puts("SET #{var}=") }
        f.puts('SET APTIBLE_TOOLBELT=1')
        f.puts("SET PATH=#{install_dir}/embedded/bin;%PATH%")
        certs = "#{install_dir}/embedded/ssl/certs"
        f.puts("SET SSL_CERT_DIR=#{certs}")
        f.puts("SET SSL_CERT_FILE=#{certs}/cacert.pem")
        f.puts(%(@"#{install_dir}/embedded/bin/aptible.bat" %*))
      else
        f.puts('#!/bin/sh')
        vars_to_clear.each { |var| f.puts("unset #{var}") }
        f.puts(%(export APTIBLE_TOOLBELT="1"))
        f.puts(%(export PATH="#{install_dir}/embedded/bin:$PATH"))
        f.puts(%(exec "#{install_dir}/embedded/bin/aptible" "$@"))
      end
    end
  end

  command "chmod 755 #{cli_entrypoint}" unless windows?
end
