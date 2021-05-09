class ZipFile
  require 'zip'
  require 'zip/filesystem'

  attr_accessor :zip, :zip_arr
  def initialize(f)
     @zip_arr = []
     @zip = Zip::File.new(f)
     @zip.each do |x|
       @zip_arr << x
     end
  end
  def namelist()
    return @zip_arr
  end

  def write(folder, name) # fname in zip
     f = open(folder + "/" + name.to_s, "wb+")
     f.write(read(name))
     f.close
     return folder + "/" + name.to_s
  end
  
  def read(fname_in_zip)
     return @zip.file.read(fname_in_zip.to_s).force_encoding('UTF-8')
  end
end
