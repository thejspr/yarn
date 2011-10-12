module Yarn
  # Creates directory listings in HTML
  class DirectoryLister

    include Logging

    # Creates a directory listing for the given path.
    def self.list(path)
      response = []
      response << <<-EOS
<html><head><title>Directory Listing</title></head><body><h1>Directory Listing</h1><table cellpadding='4'><thead><td><b>Filename</b></td><td><b>Size</b></></thead><tbody>
        EOS

      real_path = File.join(".",path)
      dir = Dir.entries(real_path).sort

      dir.each do |entry|
        size = ""
        if entry == "."
          url = ""
          name = "."
        elsif entry == ".."
          next if ["/", ""].include?(path)
          path_arr = path.split("/")
          if path_arr.size == 1
            url = ""
          else
            url = path_arr[0..path_arr.size-2].join("/")
          end
          name = ".."
        elsif File.exist?(File.join(real_path,entry))
          url = ["/", ""].include?(path) ? entry : "#{path}/#{entry}"
          name = entry
          entry_path = "#{real_path}/#{entry}"
          unless File.directory?(entry_path)
            size = format_size File.stat("#{real_path}/#{entry}").size
          end
        else
          next
        end

        url = "/#{url}"

        response << "<tr><td><a href=\"#{url}\">#{name}</a></td><td>#{size}</td></tr>"
      end

      response << ["</tbody>", "</table", "</body>", "</html>"]

      return response
    end

    # Formats file sizes into more readable formats.
    def self.format_size(size)
      count = 0
      while  size >= 1024 and count < 4
        size /= 1024.0
        count += 1
      end
      format("%.2f",size) + %w(B KB MB GB TB)[count]
    end
  end

end
