with customers as (

    select
        id as customer_id,
        first_name,
        last_name

    from {{ ref('stg_customers') }}

),

orders as (

    select
        id as order_id,
        user_id as customer_id,
        order_date,
        status

    from {{ ref('stg_orders') }}

),

customer_orders as (

    select
        to_varchar(customer_id) as cust_id,
        customer_id,

        min(order_date) as first_order_date,
        max(order_date) as most_recent_order_date,
        count(order_id) as number_of_orders

    from orders

    group by 1,2

),
country_cte as (
select customer_id as cust_id,country from {{ ref('country') }}
),
final as (

    select
        customers.customer_id,
        customers.first_name,
        customers.last_name,
        country_cte.country,
        customer_orders.first_order_date,
        customer_orders.most_recent_order_date,
        coalesce(customer_orders.number_of_orders, 0) as number_of_orders

    from customers

    left join customer_orders using (customer_id)
    left join country_cte using (cust_id)

)

select * from final


