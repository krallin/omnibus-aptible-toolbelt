name 'ssh'
default_version '7.3p1'

dependency 'zlib'
dependency 'openssl'

license 'BSD'
license_file 'LICENCE'

source url: 'http://ftp.openbsd.org/pub/OpenBSD/OpenSSH/portable/' \
            "openssh-#{version}.tar.gz"

version '7.3p1' do
  source sha1: 'bfade84283fcba885e2084343ab19a08c7d123a5'
end

relative_path "openssh-#{version}"

build do
  env = with_standard_compiler_flags(with_embedded_path)

  command './configure' \
    " --prefix=#{install_dir}/embedded", env: env

  %w(ssh-keygen ssh).each do |binary|
    make binary, env: env
    command "install -m 0755 #{binary} #{install_dir}/embedded/bin/#{binary}",
            env: env
  end
end
