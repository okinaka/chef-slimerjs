ver  = '0.9.0'
arch = 'linux-x86_64'
major = ver.slice(0, ver.rindex("."))

src_filepath = "#{Chef::Config['file_cache_path']}/slimerjs-#{ver}-#{arch}.tar.bz2"
extract_path = "#{Chef::Config['file_cache_path']}/slimerjs-#{ver}"
install_path = "/usr/local/slimerjs"
bin_path = "/usr/local/bin"

remote_file src_filepath do
  source "http://download.slimerjs.org/v#{major}/#{ver}/slimerjs-#{ver}-#{arch}.tar.bz2"
  action :create_if_missing
end

execute "apt-get update -y"

%w{unzip xulrunner-17.0 xvfb fonts-takao}.each do |pkg|
  package pkg
end

bash 'extract' do
  cwd ::File.dirname(src_filepath)
  code <<-EOH
    tar xjf #{src_filepath}
    cp -a #{extract_path} #{install_path}
  EOH
  not_if { ::File.exists?(extract_path) }
end

link "#{bin_path}/slimerjs" do
  to "#{install_path}/slimerjs"
end
