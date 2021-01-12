SELECT
	events.event_on AS 日付,
	users.name AS ユーザー名,
	events.text AS 内容,
	prices.name AS 費目,
	IF(prices.is_payment = 1,"入金","出金") AS 入出金区分,
	prices.price AS 金額,
	tags.value AS タグ
FROM
	events
LEFT JOIN users ON users.id = events.user_id
LEFT JOIN (SELECT * FROM prices JOIN expense_items ON prices.expense_item_id = expense_items.id) AS prices ON events.id = prices.event_id
LEFT JOIN events_tags ON events.id = events_tags.event_id
LEFT JOIN tags ON events_tags.tag_id = tags.id;
