# Data Model

## 1. Table Grain and Candidate Keys

A table grain defines what one row represents.

A candidate key is a minimal set of columns that uniquely identifies one row according to the table grain.

| Table                               | Grain                                         | Initial Assumption                 | Validation                                                                  | Final Candidate Key                |
| ----------------------------------- | --------------------------------------------- | ---------------------------------- | --------------------------------------------------------------------------- | ---------------------------------- |
| `olist_customers_dataset`           | One customer record                           | `customer_id`                      | Unique, non-null                                                            | `customer_id`                      |
| `olist_geolocation_dataset`         | One geolocation record for a ZIP code prefix  | None identified                    | No suitable candidate key identified                                        | None identified                    |
| `olist_orders_dataset`              | One order                                     | `order_id`                         | Unique, non-null                                                            | `order_id`                         |
| `olist_order_items_dataset`         | One item record within an order               | (`order_id`, `order_item_id`)      | Composite key unique and non-null; individual components are non-unique     | (`order_id`, `order_item_id`)      |
| `olist_order_payments_dataset`      | One payment record for an order               | (`order_id`, `payment_sequential`) | Composite key unique and non-null; individual components are non-unique     | (`order_id`, `payment_sequential`) |
| `olist_order_reviews_dataset`       | One review record associated with an order    | `review_id`                        | `review_id` is non-unique; (`order_id`, `review_id`) is unique and non-null | (`order_id`, `review_id`)          |
| `olist_products_dataset`            | One product                                   | `product_id`                       | Unique, non-null                                                            | `product_id`                       |
| `olist_sellers_dataset`             | One seller                                    | `seller_id`                        | Unique, non-null                                                            | `seller_id`                        |
| `product_category_name_translation` | One product-category name translation mapping | `product_category_name`            | Unique, non-null                                                            | `product_category_name`            |

## 2. Candidate Key Investigations

### `olist_order_reviews_dataset`

The initial candidate key assumption was `review_id`, because each row was expected to represent one review.

Validation showed that `review_id` is non-null but not unique. Further inspection showed that some `review_id` values are associated with multiple `order_id` values, while some `order_id` values are associated with multiple `review_id` values.

The composite key (`order_id`, `review_id`) was therefore tested.

Validation results:

* `order_id` alone is not unique.
* `review_id` alone is not unique.
* (`order_id`, `review_id`) contains no null values.
* (`order_id`, `review_id`) contains no duplicate combinations.

Therefore, (`order_id`, `review_id`) is used as the candidate key for the raw reviews dataset.

## 3. Relationships



## 4. Cardinality



## 5. Proposed Relational Model


