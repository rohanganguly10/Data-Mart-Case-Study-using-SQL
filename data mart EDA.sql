# DATA EXPLORATION
## Q1. Which week numbers are missing from the dataset?
create table seq100
(x int not null auto_increment primary key);
insert into seq100 values (),(),(),(),(),(),(),(),(),();
insert into seq100 values (),(),(),(),(),(),(),(),(),();
insert into seq100 values (),(),(),(),(),(),(),(),(),();
insert into seq100 values (),(),(),(),(),(),(),(),(),();
insert into seq100 values (),(),(),(),(),(),(),(),(),();
insert into seq100 select x + 50 from seq100;
select * from seq100

create table seq52 as(select x from seq100 limit 52);
select * from seq52

select distinct week_number from clean_weekly_sales;
select x from seq52 where x not in (select distinct week_number from clean_weekly_sales);

## Q2. How many total transactions were there for each year in the dataset?
select calendar_year, sum(transactions) as total_transactions from clean_weekly_sales group by calendar_year

## Q3. What are the total sales for each region for each month?
select month_number, region , sum(sales) as total_sales from clean_weekly_sales
group by month_number, region
order by month_number, region

## Q4.What is the total count of transactions for each platform
select platform, sum(transactions) as total_transactions_count from clean_weekly_sales
group by platform

## Q5.What is the percentage of sales for Retail vs Shopify for each month?
with cte_monthly_platform_sales as(
select calendar_year, month_number, platform, sum(sales) as monthly_sales from clean_weekly_sales 
group by calendar_year, month_number, platform)

select calendar_year, month_number,
round(100 * max(case
when platform = 'Retail' then monthly_sales else null end)/sum(monthly_sales),2) as 'Retail_sales_percent',
round(100 * max(case
when platform = 'Shopify' then monthly_sales else null end)/sum(monthly_sales),2) as 'Shopify_sales_percent'
from cte_monthly_platform_sales
group by calendar_year, month_number
order by calendar_year, month_number

## Q6.What is the percentage of sales by demographic for each year in the dataset?
with cte_demographic_sales as(
select calendar_year, demographic, sum(sales) as yearly_sales
from clean_weekly_sales
group by calendar_year, demographic)

select calendar_year, 
round(100*max(case when demographic = 'Couples' then yearly_sales else null end)/ sum(yearly_sales),2) as 'Couples_sales',
round(100*max(case when demographic = 'Families' then yearly_sales else null end)/ sum(yearly_sales),2) as 'Families_sales',
round(100*max(case when demographic = 'Unknown' then yearly_sales else null end)/ sum(yearly_sales),2) as 'Unknown_sales'
from cte_demographic_sales
group by calendar_year

## Q7.Which age_band and demographic values contribute the most to Retail sales?
select age_band, demographic, sum(sales) as total_sales from clean_weekly_sales
where platform = 'Retail'
group by age_band, demographic
order by age_band desc, demographic desc