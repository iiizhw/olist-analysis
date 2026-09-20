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

## 3. Relationships and Cardinality

| Parent Table                        | Child Table                    | Key                     | Observed Cardinality | Child Null Records | Orphan Records |                                                                                                               Parent Without Child | Notes                                                                       |
| ----------------------------------- | ------------------------------ | ----------------------- | -------------------- | -----------------: | -------------: | ---------------------------------------------------------------------------------------------------------------------------------: | --------------------------------------------------------------------------- |
| `olist_customers_dataset`           | `olist_orders_dataset`         | `customer_id`           | 1:1                  |                  0 |              0 |                                                                                                                                  0 | Each `customer_id` is associated with exactly one order in the raw dataset. |
| `olist_orders_dataset`              | `olist_order_items_dataset`    | `order_id`              | 1:0..N               |                  0 |              0 |                                                                                                                                775 | Most orders without item records are `unavailable` or `canceled`.           |
| `olist_orders_dataset`              | `olist_order_payments_dataset` | `order_id`              | 1:0..N               |                  0 |              0 |                                                                                                                                  1 | One delivered order has no corresponding payment record.                    |
| `olist_orders_dataset`              | `olist_order_reviews_dataset`  | `order_id`              | 1:0..N               |                  0 |              0 |                                                                                                                                768 | Some orders have no reviews, while some have multiple review records.       |
| `olist_products_dataset`            | `olist_order_items_dataset`    | `product_id`            | 1:1..N               |                  0 |              0 |                                                                                                                                  0 | All products appear in at least one order-item record.                      |
| `olist_sellers_dataset`             | `olist_order_items_dataset`    | `seller_id`             | 1:1..N               |                  0 |              0 |                                                                                                                                  0 | All sellers appear in at least one order-item record.                       |
| `product_category_name_translation` | `olist_products_dataset`       | `product_category_name` | 1:N                  |                610 |             13 | 610 products have no category value. Another 13 product records use 2 category values that are missing from the translation table. |                                                                             |

### Relationship Exceptions

#### Orders without item records

775 orders have no corresponding records in `olist_order_items_dataset`.

Most are associated with incomplete or unsuccessful order states:

* `unavailable`: 603
* `canceled`: 164
* `created`: 5
* `invoiced`: 2
* `shipped`: 1

#### Order without payment record

One delivered order has no corresponding record in `olist_order_payments_dataset`.

This is retained as a raw-data exception rather than treated as evidence that the relationship is invalid.

#### Missing product-category translations

13 product records contain a non-null `product_category_name` that does not exist in `product_category_name_translation`.

The unmatched categories are:

* `portateis_cozinha_e_preparadores_de_alimentos`: 10 products
* `pc_gamer`: 3 products

Separately, 610 product records have a null `product_category_name`.




## 4. Proposed Relational Model


