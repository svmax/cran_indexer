def download_archive(name, version)
  file_name = "#{name}_#{version}.tar.gz"
  fix_file = [Rails.root, 'spec', 'fixtures', 'files', file_name].join('/')
  File.open(Tempfile.new(file_name), 'w') do |file|
    file.binmode
    file.write File.open(fix_file).read
    file.flush
    file.close
    file
  end
end