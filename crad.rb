print "Location: http://localhost/\n\n"
#print "Content-type: text/html\n\n"

require 'cgi'
cgi = CGI.new
pattern = cgi["crad_pattern"]
print cgi.params

require 'mysql2'
client = Mysql2::Client.new(:host => "localhost",:username => "root",:password => "mysql", :database => "kakeibo_db")

if pattern == "insert_users"
  name = cgi["name"]
  statement = client.prepare("INSERT INTO users(name) VALUES(?)")
  statement.execute(name)
end

if pattern == "insert_expense_items"
  name = cgi["name"]
  is_payment = cgi["is_payment"]
  statement = client.prepare("INSERT INTO expense_items(name,is_payment) VALUES(?,?)")
  statement.execute(name,is_payment)
end

if pattern == "insert_tags"
  value = cgi["value"]
  statement = client.prepare("INSERT INTO tags(value) VALUES(?)")
  statement.execute(value)
end

if pattern == "insert_events"
  text = cgi["text"]
  event_on = cgi["event_on"]
  user_id = cgi["user_id"]
  events_statement = client.prepare("INSERT INTO events(text,event_on,user_id) VALUES(?,?,?)")

  expense_item_id = cgi["expense_item_id"]
  price = cgi["price"]
  prices_statement = client.prepare("INSERT INTO prices(event_id,expense_item_id,price) VALUES(?,?,?)")

  client.query("begin")
    events_statement.execute(text,event_on,user_id)    
    prices_statement.execute(client.last_id,expense_item_id,price)
  client.query("commit")
end
