-- 1. Row counts

SELECT 'customers' AS table_name, COUNT(*) AS row_count
FROM raw.customers

UNION ALL
SELECT 'geolocation', COUNT(*)
FROM raw.geolocation

UNION ALL
SELECT 'order_items', COUNT(*)
FROM raw.order_items

UNION ALL
SELECT 'order_payments', COUNT(*)
FROM raw.order_payments

UNION ALL
SELECT 'order_reviews', COUNT(*)
FROM raw.order_reviews

UNION ALL
SELECT 'orders', COUNT(*)
FROM raw.orders

UNION ALL
SELECT 'products', COUNT(*)
FROM raw.products

UNION ALL
SELECT 'sellers', COUNT(*)
FROM raw.sellers

UNION ALL
SELECT 'product_category_name_translation', COUNT(*)
FROM raw.product_category_name_translation;


-- 2. Single-column candidate keys

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT customer_id) AS distinct_keys
FROM raw.customers;

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT order_id) AS distinct_keys
FROM raw.orders;

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT product_id) AS distinct_keys
FROM raw.products;

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT seller_id) AS distinct_keys
FROM raw.sellers;

-- order_items composite key

SELECT COUNT(*) AS duplicate_key_groups
FROM (
    SELECT
        order_id,
        order_item_id
    FROM raw.order_items
    GROUP BY
        order_id,
        order_item_id
    HAVING COUNT(*) > 1
) AS duplicates;

SELECT COUNT(*) AS duplicate_key_groups
FROM (
    SELECT
        order_id,
        payment_sequential
    FROM raw.order_payments
    GROUP BY
        order_id,
        payment_sequential
    HAVING COUNT(*) > 1
) AS duplicates;

SELECT COUNT(*) AS duplicate_key_groups
FROM (
    SELECT
        order_id,
        review_id
    FROM raw.order_reviews
    GROUP BY
        order_id,
        review_id
    HAVING COUNT(*) > 1
) AS duplicates;


-- 3. Key null checks

SELECT
    COUNT(*) FILTER (WHERE order_id IS NULL) AS null_order_id,
    COUNT(*) FILTER (WHERE customer_id IS NULL) AS null_customer_id
FROM raw.orders;

SELECT
    COUNT(*) FILTER (WHERE order_id IS NULL) AS null_order_id,
    COUNT(*) FILTER (WHERE order_item_id IS NULL) AS null_order_item_id,
    COUNT(*) FILTER (WHERE product_id IS NULL) AS null_product_id,
    COUNT(*) FILTER (WHERE seller_id IS NULL) AS null_seller_id
FROM raw.order_items;

SELECT
    COUNT(*) AS null_product_categories
FROM raw.products
WHERE product_category_name IS NULL;

-- 4. Known relationship exceptions

-- Orders without items
SELECT COUNT(*) AS orders_without_items
FROM raw.orders AS o
WHERE NOT EXISTS (
    SELECT 1
    FROM raw.order_items AS oi
    WHERE oi.order_id = o.order_id
);

SELECT COUNT(*) AS orders_without_payments
FROM raw.orders AS o
WHERE NOT EXISTS (
    SELECT 1
    FROM raw.order_payments AS p
    WHERE p.order_id = o.order_id
);

SELECT COUNT(*) AS orphan_product_categories
FROM raw.products AS p
WHERE p.product_category_name IS NOT NULL
  AND NOT EXISTS (
      SELECT 1
      FROM raw.product_category_name_translation AS t
      WHERE t.product_category_name = p.product_category_name
  );

SELECT COUNT(DISTINCT p.product_category_name) AS distinct_orphan_categories
FROM raw.products AS p
WHERE p.product_category_name IS NOT NULL
  AND NOT EXISTS (
      SELECT 1
      FROM raw.product_category_name_translation AS t
      WHERE t.product_category_name = p.product_category_name
  );