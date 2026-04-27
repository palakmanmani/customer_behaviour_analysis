
create database customer_behaviour;
use customer_behaviour;
select * from cleaned_data limit 10;

-- what is the total revenue genrated by male vs female
select gender,sum(purchase_amount) as revenue
from cleaned_data
group by gender


-- which customer used discount but still spend more than the average purchase amount?

SELECT customer_id , purchase_amount
from cleaned_data 
where discount_applied ='yes'
 and purchase_amount > (select avg(purchase_amount)
 from cleaned_data)
 );


-- which are the top 5 product with the highest average review rating

select item_purchased,avg(review_rating)as average_product_rating
from cleaned_data
group by item_purchased
order by avg(review_rating) desc
limit 5;


-- compare the average purchase amout between standard and express shipping?

select shipping_type,avg(purchase_amount)
from cleaned_data
where shipping_type in ( 'standard','express')
group by shipping_type

-- do subscribed customer spend more?compare average spend and total revenue between subscriber and non subscriber?

select subscription_status,
count(customer_id),
round (avg(purchase_amount),2) as average_spend,
round(sum(purchase_amount),2) as total_revenue
from cleaned_data
group by subscription_status
order by average_spend,total_revenue desc;


-- which 5 product have the highest percentage of purchase with discount applied?
select item_purchased,
ROUND(
     sum(case
         when discount_applied ='Yes' then 1 else 0 end) / count(*) *100,2) as discount_rate
from cleaned_data 
group by item_purchased
order by discount_rate desc
limit 5;


-- segment customer into new,returning,loyal based on their total number of previous purchases ,and show the count of each segment

with customer_type as(
select customer_id,previous_purchases,
case
  when previous_purchases= 1 then 'new'
  when previous_purchases between 2 and 10 then'returning'
  else 'loyal'
  end as customer_segment
from cleaned_data
)
select customer_segment,count(*) as "num_of_customer"
from customer_type
group by customer_segment;


-- what are the top 3 product purchased in each category

with item_count as(
select category,
item_purchased,
count(customer_id) as total_orders,
row_number()over (partition by category order by count(customer_id)desc) as item_rank
from cleaned_data
group by category,item_purchased
)

select item_rank,category,item_purchased,total_orders
from item_count
where item_rank<=3;

-- are customer who are repeat buyer(more than 5 previous purchase) also likely to subscribe

select subscription_status,
count(customer_id)as repeat_buyer
from cleaned_data
where previous_purchases>5
group by subscription_status;


-- what is the revenue contribution of each age group?
select age_group,
sum(purchase_amount) as total_revenue
from cleaned_data
group by age_group;
