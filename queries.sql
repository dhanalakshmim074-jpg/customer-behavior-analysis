
select * from customer.customer;
select gender,sum(purchase_amount) as revenue from customer.customer
group by gender;
select avg(purchase_amount) as avgpur from customer.customer;


select customer_id,purchase_amount from customer.customer
where discount_applied ='Yes' and purchase_amount>=(select avg(purchase_amount) as avgpur from customer.customer);

with neww as(select item_purchased,round(avg(review_rating),2) as ar from customer.customer
group by item_purchased)
select item_purchased,ar from neww
order by ar desc
limit 5;
select shipping_type, round(avg(purchase_amount),2) as pr from customer.customer
where shipping_type in('Express','Standard')
group by shipping_type;
select subscription_status,count(purchase_amount),sum(purchase_amount),avg(purchase_amount) from customer.customer
group by  subscription_status;
select item_purchased,round((sum(case when discount_applied = 'Yes' then 1 else 0 end)/count(*))*100,2) as perc from customer.customer
group by item_purchased
order by perc desc
limit 5;
select bs,count(bs) from(select *,(case when segment=1 then "loyal" 
when segment=2 then "returning" else "new" end)as bs from
(select * ,NTILE(3) OVER (ORDER BY previous_purchases desc) as segment from customer.customer)m)mm
group by bs;
select * from (select *,(row_number()over(partition by category order by d desc))as rankk  from(select category,item_purchased,count(item_purchased) as d from customer.customer
group by category,item_purchased
order by category)b)dg
where rankk <=3;
select count(*),(select count(*) from customer.customer where subscription_status='Yes') as total_subscriber from customer.customer
where previous_purchases >=5 and subscription_status='Yes';
select subscription_status,count(*) from customer.customer
where previous_purchases >=5
group by subscription_status;

select age_group, sum(purchase_amount) as total_revenue from customer.customer
group by age_group
order by total_revenue desc;