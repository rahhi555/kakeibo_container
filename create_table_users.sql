CREATE TABLE users(
    id INT AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL CHECK(name REGEXP '^[^ 0-9a-zA-Z　]+　[^ 0-9a-zA-Z　]+$'),
    PRIMARY KEY(id)
);
CREATE TABLE events(
    id INT AUTO_INCREMENT,
    text VARCHAR(255) NOT NULL,
    event_on DATE NOT NULL,
    user_id INT NOT NULL,
    PRIMARY KEY(id),
    FOREIGN KEY(user_id) REFERENCES users(id)
);
CREATE TABLE expense_items(
    id INT AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL UNIQUE,
    is_payment BOOLEAN NOT NULL,
    PRIMARY KEY(id)
);
CREATE TABLE prices(
    event_id INT NOT NULL,
    expense_item_id INT NOT NULL,
    price DECIMAL UNSIGNED NOT NULL,
    FOREIGN KEY(event_id) REFERENCES events(id),
    FOREIGN KEY(expense_item_id) REFERENCES expense_items(id)
);
CREATE TABLE tags(
    id INT AUTO_INCREMENT,
    value VARCHAR(255) NOT NULL UNIQUE,
    PRIMARY KEY(id)
);
CREATE TABLE events_tags(
    event_id INT NOT NULL,
    tag_id INT NOT NULL,
    FOREIGN KEY(event_id) REFERENCES events(id),
    FOREIGN KEY(tag_id) REFERENCES tags(id)
);
