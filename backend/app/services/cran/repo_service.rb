# frozen_string_literal: true

module Cran
  class RepoService
    extend ApiMixin

    ASSOCIATIONS = {
      'Title' => :title,
      'Author' => :authors,
      'Version' => :number,
      'Authors' => :authors,
      'Maintainer' => :maintainers,
      'Maintainers' => :maintainers,
      'Description' => :description,
      'Date/Publication' => :published_at
    }.freeze

    class << self
      def receive_description(package_name, version)
        package_dir_name = "#{package_name}_#{version}"
        tmp_dir_path = "#{Dir.tmpdir}/#{package_dir_name}"
        dest_dir_name = "#{package_name}/DESCRIPTION"

        create_tmp_dir(tmp_dir_path)
        archive = download_archive(package_dir_name)
        unzip_description(archive.path, tmp_dir_path, dest_dir_name)
        description = extract_description(tmp_dir_path, dest_dir_name)
        clean_all(archive, tmp_dir_path)
        ensure_readable_fields(description)
      end

      private

      # Sometimes some archives are not available for download.
      # It looks like they are not uploaded to the store,
      # or some mistake from the Cran server
      def download_archive(package_dir_name)
        file_name = "#{package_dir_name}.tar.gz"
        url = "#{HOST}/#{CONTRIB_DIR_URL}/#{file_name}"
        File.open(Tempfile.new(file_name), 'w') do |file|
          file.binmode
          file.write URI.open(url).read
          file.flush
          file.close
          file
        end
      end

      def unzip_description(file_path, tmp_dir_path, dest_dir_name)
        cmd = "tar -C #{tmp_dir_path} -zxf #{file_path} #{dest_dir_name}"
        success = system(cmd)
        return if success && $?.exitstatus.zero?

        raise "Could not unzip the file! Path: #{file_path}"
      end

      def extract_description(tmp_dir_path, dest_dir_name)
        output = {}
        File.open([tmp_dir_path, dest_dir_name].join('/'), 'r') do |f|
          prev_title = ''
          f.each_line do |line|
            line = line.encode('UTF-8', invalid: :replace, replace: '')
            splitted_line = line.split(':', 2)
            next until splitted_line.any?

            current_title = clean_string(splitted_line.first)
            content = splitted_line.last&.strip

            if title_word?(current_title)
              key = ASSOCIATIONS[current_title]
              output[key] = clean_string(content) if key
              prev_title = current_title
            else
              key = ASSOCIATIONS[prev_title]
              output[key] += clean_string(content) if key
            end
          end
        end
        output
      end

      def ensure_readable_fields(hash)
        hash[:maintainers] = extract_names_and_emails(hash[:maintainers])
        hash[:authors] = extract_names_and_emails(hash[:authors])
        hash
      end

      def extract_names_and_emails(data)
        email_regex = /\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\b/i.freeze
        chars_and_spaces_regex = /[^A-Za-z ]/
        brackets_regex = /\[.*?\]/
        data.gsub(brackets_regex, '').split(',').map do |str|
          email = str.scan(email_regex)&.first
          name = (email ? str.remove(email) : str).gsub(chars_and_spaces_regex, '').strip
          { email: email, name: name }
        end
      end

      def title_word?(str)
        str.scan(/[A-Z]/).length >= 1 && (str =~ / /).nil?
      end

      def clean_string(str)
        return '' if str.blank?

        str.delete("\t\r\n").strip
      end

      def create_tmp_dir(path)
        return if File.exist?(path)

        Dir.mkdir(path, 0o700)
      end

      def clean_all(archive, tmp_dir_path)
        FileUtils.remove_file(archive.path, true)
        FileUtils.rm_rf(tmp_dir_path)
        nil
      end
    end
  end
end
