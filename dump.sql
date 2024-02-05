-- promotion
CREATE TABLE promotion (
    id INT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    discount_rate DECIMAL(10, 2) NOT NULL,
    start_date TIMESTAMP NOT NULL,
    end_date TIMESTAMP NOT NULL
);

-- shipping_method
CREATE TABLE shipping_method (
    id INT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    price DECIMAL(10, 2) NOT NULL
);

-- country
CREATE TABLE country (
    id INT PRIMARY KEY,
    country_name VARCHAR(255) NOT NULL
);

-- address
CREATE TABLE address (
    id INT PRIMARY KEY,
    unit_number VARCHAR(20),
    street_number VARCHAR(20),
    address_line1 VARCHAR(255) NOT NULL,
    address_line2 VARCHAR(255),
    city VARCHAR(255) NOT NULL,
    region VARCHAR(255),
    postal_code VARCHAR(20) NOT NULL,
    country_id INT NOT NULL,
    FOREIGN KEY (country_id) REFERENCES country(id)
);

-- payment_type
CREATE TABLE payment_type (
    id INT PRIMARY KEY,
    value VARCHAR(255) NOT NULL
);

-- site_user
CREATE TABLE site_user (
    id INT PRIMARY KEY,
    email_address VARCHAR(255) NOT NULL,
    phone_number VARCHAR(20),
    password VARCHAR(255) NOT NULL,
    isAdmin BOOLEAN NOT NULL
);

-- product_category
CREATE TABLE product_category (
    id INT PRIMARY KEY,
    parent_category_id INT NOT NULL REFERENCES product_category(id),
    category_name VARCHAR(255) NOT NULL
);

-- product
CREATE TABLE product (
    id INT PRIMARY KEY,
    category_id INT NOT NULL,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    product_image VARCHAR(255),
    admin_id INT NOT NULL REFERENCES site_user(id),
    FOREIGN KEY (category_id) REFERENCES product_category(id)
);

-- product_item
CREATE TABLE product_item (
    id INT PRIMARY KEY,
    product_id INT NOT NULL,
    sku VARCHAR(255) NOT NULL,
    quantity_in_stock INT NOT NULL,
    product_image VARCHAR(255),
    price DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (product_id) REFERENCES product(id)
);

-- user_payment_method
CREATE TABLE user_payment_method (
    id INT PRIMARY KEY,
    user_id INT NOT NULL,
    payment_type_id INT NOT NULL,
    provider VARCHAR(255),
    account_number VARCHAR(255),
    expiry_date DATE,
    is_default BOOLEAN,
    FOREIGN KEY (user_id) REFERENCES site_user(id),
    FOREIGN KEY (payment_type_id) REFERENCES payment_type(id)
);

-- user_address
CREATE TABLE user_address (
    user_id INT NOT NULL,
    address_id INT NOT NULL,
    is_default BOOLEAN NOT NULL,
    PRIMARY KEY (user_id, address_id),
    FOREIGN KEY (user_id) REFERENCES site_user(id),
    FOREIGN KEY (address_id) REFERENCES address(id)
);

-- order_status
CREATE TABLE order_status (
    id INT PRIMARY KEY,
    status ENUM('Pending', 'Processing', 'Shipped', 'Delivered') NOT NULL
);

-- shopping_cart
CREATE TABLE shopping_cart (
    id INT PRIMARY KEY,
    user_id INT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES site_user(id)
);

-- shop_order
CREATE TABLE shop_order (
    id INT PRIMARY KEY,
    user_id INT NOT NULL,
    order_date DATE NOT NULL,
    payment_method_id INT NOT NULL,
    shipping_address INT NOT NULL,
    shipping_method INT NOT NULL,
    order_total DECIMAL(10, 2) NOT NULL,
    order_status ENUM('Pending', 'Processing', 'Shipped', 'Delivered') NOT NULL,
    FOREIGN KEY (user_id) REFERENCES site_user(id),
    FOREIGN KEY (payment_method_id) REFERENCES user_payment_method(id),
    FOREIGN KEY (shipping_address) REFERENCES user_address(user_id),
    FOREIGN KEY (shipping_method) REFERENCES shipping_method(id),
    FOREIGN KEY (order_status) REFERENCES order_status(id)
);

CREATE TABLE order_line (
    id INT PRIMARY KEY,
    product_item_id INT,
    order_id INT,
    quantity INT NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (product_item_id) REFERENCES product_item(id),
    FOREIGN KEY (order_id) REFERENCES shop_order(id)
);
-- user_review
CREATE TABLE user_review (
    id INT PRIMARY KEY,
    user_id INT NOT NULL,
    ordered_product_id INT NOT NULL,
    rating_value INT,
    comment TEXT,
    FOREIGN KEY (user_id) REFERENCES site_user(id),
    FOREIGN KEY (ordered_product_id) REFERENCES order_line(id)
);

-- promotion_category
CREATE TABLE promotion_category (
    category_id INT NOT NULL,
    promotion_id INT NOT NULL,
    PRIMARY KEY (category_id, promotion_id),
    FOREIGN KEY (category_id) REFERENCES product_category(id),
    FOREIGN KEY (promotion_id) REFERENCES promotion(id)
);

-- variation
CREATE TABLE variation (
    id INT PRIMARY KEY,
    category_id INT NOT NULL,
    name VARCHAR(255) NOT NULL,
    FOREIGN KEY (category_id) REFERENCES product_category(id)
);

-- variation_option
CREATE TABLE variation_option (
    id INT PRIMARY KEY,
    variation_id INT NOT NULL,
    value VARCHAR(255) NOT NULL,
    FOREIGN KEY (variation_id) REFERENCES variation(id)
);

-- shopping_cart_item
CREATE TABLE shopping_cart_item (
    id INT PRIMARY KEY,
    cart_id INT NOT NULL,
    product_item_id INT NOT NULL,
    quantity INT NOT NULL,
    FOREIGN KEY (cart_id) REFERENCES shopping_cart(id),
    FOREIGN KEY (product_item_id) REFERENCES product_item(id)
);

-- product_configuration
CREATE TABLE product_configuration (
    product_item_id INT NOT NULL,
    variation_option_id INT NOT NULL,
    PRIMARY KEY (product_item_id, variation_option_id),
    FOREIGN KEY (product_item_id) REFERENCES product_item(id),
    FOREIGN KEY (variation_option_id) REFERENCES variation_option(id)
);


