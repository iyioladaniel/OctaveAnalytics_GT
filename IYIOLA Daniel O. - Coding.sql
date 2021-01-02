/*1. insert into the RESULTS table each customer id, and the number of unique products purchased by that customer.*/

INSERT INTO RESULTS (customer_id, product_count)
SELECT		DISTINCT customer_id,
		COUNT(product_id) AS 'Number of Unique Products'
FROM		CUST_PRODUCTS
GROUP BY	customer_id
ORDER BY	customer_id;

/*2. update the recently_purchased column of the customer table to 'Y' (yes if they have purchased a product in the last 12 months) or 'N' (if they have not purchased a product in the last 12 months).*/

UPDATE 	CUSTOMER,
LEFT JOIN CUST_PRODUCTS ON CUSTOMER.customer_id = CUST_PRODUCTS.customer_id
	SET recently_purchased = (
		CASE
			WHEN CUST_PRODUCTS.date_purchased >= CURDATE()  - INTERVAL 12 MONTH THEN 'Y'
			ELSE 'N'
		END);

