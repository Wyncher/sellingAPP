CREATE TABLE products (
                          id SERIAL PRIMARY KEY,
                          name TEXT NOT NULL,
                          category TEXT NOT NULL,
                          price NUMERIC(10,2) NOT NULL,
                          quantity INT NOT NULL
);
