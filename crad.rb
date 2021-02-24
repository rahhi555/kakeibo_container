print "Location: https://www.hirabayashi.work/\n\n"
#print "Content-type: text/html\n\n"

require 'cgi'
cgi = CGI.new
pattern = cgi["crad_pattern"]
print cgi
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
  tag_id = cgi["tag_id"]
  events_statement = client.prepare("INSERT INTO events(text,event_on,user_id) VALUES(?,?,?)")
  
  expense_item_id = cgi["expense_item_id"]
  price = cgi["price"]
  prices_statement = client.prepare("INSERT INTO prices(event_id,expense_item_id,price) VALUES(?,?,?)")

  events_tags_statement = client.prepare("INSERT INTO events_tags(event_id,tag_id) VALUES(?,?)")

  client.query("begin")
    events_statement.execute(text,event_on,user_id)
    last_event_id = client.last_id
    prices_statement.execute(last_event_id,expense_item_id,price)
    events_tags_statement.execute(last_event_id,tag_id) unless tag_id.empty?
  client.query("commit")

end


if pattern == "update"
  event_id = cgi["event_id"]
  event_on = cgi["event_on"]
  user_id = cgi["user_id"]
  event_text = cgi["event_text"]
  before_expense_item_id = cgi["before_expense_item_id"]
  expense_item_id = cgi["expense_item_id"]
  price = cgi["price"]
  before_tag_id = cgi["before_tag_id"]
  tag_id = cgi["tag_id"]
  users_statement = client.prepare("UPDATE events SET text = ?,event_on = ?, user_id = ? WHERE id = ?")
  prices_statement = client.prepare("UPDATE prices SET price = ?,expense_item_id = ? WHERE event_id = ? AND expense_item_id = ?")

  client.query("begin")
    users_statement.execute(event_text,event_on,user_id,event_id)
    prices_statement.execute(price,expense_item_id,event_id,before_expense_item_id)
    
    if !before_tag_id.empty? && tag_id.empty?
      events_tags_statement = client.prepare("DELETE FROM events_tags WHERE event_id = ? AND tag_id = ?")
      events_tags_statement.execute(event_id,before_tag_id)
    elsif !before_tag_id.empty? && !tag_id.empty?
      events_tags_statement = client.prepare("UPDATE events_tags SET event_id = ?,tag_id = ? WHERE event_id = ? AND tag_id = ?")
      events_tags_statement.execute(event_id,tag_id,event_id,before_tag_id)
    elsif before_tag_id.empty? && !tag_id.empty?
      events_tags_statement = client.prepare("INSERT INTO events_tags(event_id,tag_id) VALUES(?,?)")
      events_tags_statement.execute(event_id,tag_id)
    end
  client.query("commit")
end
