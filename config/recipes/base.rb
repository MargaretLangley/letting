# Reads templates and evaluates them before being passed onto server
# How template result / binding works.
# http://stackoverflow.com/questions/10236049/including-one-erb-file-into-another

def template(from, to)
  erb = File.read(File.expand_path("../templates/#{from}", __FILE__))
  # put doesn't work under sudo so we have
  # to put the file onto the server - which will be moved later
  put ERB.new(erb).result(binding), to
end

def set_default(name, *args, &block)
  set(name, *args, &block) unless exists?(name)
end

