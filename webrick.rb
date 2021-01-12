require 'webrick'
config = {
  :DocumentRoot => './',
  :Port => 80,
  :CGIInterpreter => '/usr/bin/ruby',
}
s = WEBrick::HTTPServer.new(config)
s.config[:MimeTypes]["erb"] = "text/html"
WEBrick::HTTPServlet::FileHandler.add_handler("erb", WEBrick::HTTPServlet::ERBHandler)
s.mount('/',WEBrick::HTTPServlet::ERBHandler,'index.erb')	
s.mount('/crad.rb',WEBrick::HTTPServlet::CGIHandler, 'crad.rb')
trap("INT"){s.shutdown}
s.start
