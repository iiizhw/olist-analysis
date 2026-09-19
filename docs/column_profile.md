1. olist_customers_dataset:
	identifiers: customer_id,customer_unique_id
	categorical: customer_city, customer_state
	datetime fields: 0
	numeric measures: 0
	geographic code: customer_zip_code_prefix
	meaningful missingness: 0
	surprisingly high or low cardinality: 0

2. olist_geolocation_dataset:
	identifiers: 0
	categorical: geolocation_city, geolocation_state
	datetime fields: 0
	numeric measures: geolocation_lat, geolocation_lng
	geographic code: geolocation_zip_code_prefix
  	meaningful missingness: 0
	surprisingly high or low cardinality: 0

3. olist_orders_dataset: 
	identifiers: order_id, customer_id
	categorical: order_status
	datetime fields: order_purchase_timestamp, order_approved_at, order_delivered_carrier_date, order_delivered_customer_date, order_estimated_delivery_date
	numeric measures: 0
	meaningful missingness: order_approved_at, order_delivered_carrier_date, order_delivered_customer_date
	surprisingly high or low cardinality: 0

4. olist_order_items_dataset:
	identifiers: order_id, product_id, seller_id
	categorical: 0
	sequence / ordinal: order_item_id
	datetime fields: shipping_limit_date
	numeric measures: price, freight_value
  	meaningful missingness: 0
	surprisingly high or low cardinality: 0

5. olist_order_payments_dataset:
	identifiers: order_id
	categorical: payment_type
	sequence / ordinal: payment_sequential
	datetime fields: 0
	numeric measures: payment_installments, payment_value
  	meaningful missingness: 0 
	surprisingly high or low cardinality: 0

6. olist_order_reviews_dataset:
	identifiers: review_id, order_id
	ordinal categorical: review_score
	datetime fields: review_creation_date, review_answer_timestamp
  	meaningful missingness: review_comment_title, review_comment_message
	surprisingly high or low cardinality: 0

7. olist_products_dataset:
	identifiers: product_id
	categorical: product_category_name
	datetime fields: 
	numeric measures: product_name_lenght, product_description_lenght, product_photos_qty, product_weight_g, product_length_cm, product_height_cm, product_width_cm
  	meaningful missingness: product_category_name, product_name_lenght, product_description_lenght, product_photos_qty
	surprisingly high or low cardinality: 0

8. olist_sellers_dataset:
	identifiers: seller_id
	categorical: seller_city, seller_state
	datetime fields: 0
	numeric measures: 0
	geographic code: seller_zip_code_prefix
  	meaningful missingness: 0
	surprisingly high or low cardinality: 0

9. product_category_name_translation:
	mapping fields: product_category_name, product_category_name_english


