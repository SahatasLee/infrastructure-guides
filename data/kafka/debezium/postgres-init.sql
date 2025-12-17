CREATE TABLE customers (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL
);

ALTER TABLE customers REPLICA IDENTITY FULL;

INSERT INTO customers (first_name, last_name, email) VALUES 
('Sally', 'Thomas', 'sally.thomas@acme.com'),
('George', 'Bailey', 'gbailey@foobar.com'),
('Edward', 'Walker', 'ed@walker.com'),
('Anne', 'Kretchmar', 'annek@noanswer.org');
