require 'webrick'
config = {
  :DocumentRoot => './',
  :Port => 80,
  :CGIInterpreter => '/usr/bin/ruby -Eutf-8:utf-8',
}
s = WEBrick::HTTPServer.new(config)
s.config[:MimeTypes]["erb"] = "text/html"
WEBrick::HTTPServlet::FileHandler.add_handler("erb", WEBrick::HTTPServlet::ERBHandler)
s.mount('/',WEBrick::HTTPServlet::ERBHandler,'index.erb')	
s.mount('/update_or_delete.erb',WEBrick::HTTPServlet::ERBHandler,'update_or_delete.erb')	
s.mount('/crad.rb',WEBrick::HTTPServlet::CGIHandler, 'crad.rb')
trap("INT"){s.shutdown}
s.start
