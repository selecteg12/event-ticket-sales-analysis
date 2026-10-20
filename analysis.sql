-- 1. Overview by currency
SELECT 
    currency_code,
    SUM(revenue) AS total_revenue,
    COUNT(order_id) AS total_orders,
    AVG(revenue) AS avg_revenue_per_order,
    COUNT(DISTINCT user_id) AS total_users
FROM afisha.purchases
GROUP BY currency_code
ORDER BY total_revenue DESC;

-- 2. Revenue by device (RUB)
WITH set_config_precode AS (
    SELECT set_config('synchronize_seqscans', 'off', true)
)
SELECT 
    COALESCE(device_type_canonical, 'unknown') AS device_type_canonical,
    SUM(revenue) AS total_revenue,
    COUNT(order_id) AS total_orders,
    AVG(revenue) AS avg_revenue_per_order,
    ROUND(
        (SUM(revenue) * 1.0 / (
            SELECT SUM(revenue) 
            FROM afisha.purchases 
            WHERE currency_code = 'rub' 
              AND revenue IS NOT NULL
        ))::NUMERIC, 
        3
    ) AS revenue_share
FROM afisha.purchases
WHERE currency_code = 'rub' 
  AND revenue IS NOT NULL
GROUP BY device_type_canonical
ORDER BY revenue_share DESC;

-- 3. Revenue by event category (RUB)
SELECT 
    e.event_type_main,
    SUM(p.revenue) AS total_revenue,
    COUNT(p.order_id) AS total_orders,
    AVG(p.revenue) AS avg_revenue_per_order,
    COUNT(DISTINCT e.event_name_code) AS total_event_name,
    AVG(p.tickets_count) AS avg_tickets,
    SUM(p.revenue) / NULLIF(SUM(p.tickets_count), 0) AS avg_ticket_revenue,
    ROUND(
        (SUM(p.revenue) * 1.0 / (
            SELECT SUM(revenue) 
            FROM afisha.purchases 
            WHERE currency_code = 'rub' 
              AND revenue IS NOT NULL
        ))::NUMERIC, 
        3
    ) AS revenue_share
FROM afisha.purchases p
INNER JOIN afisha.events e ON p.event_id = e.event_id
WHERE p.currency_code = 'rub' 
  AND p.revenue IS NOT NULL
  AND e.event_type_main IS NOT NULL
GROUP BY e.event_type_main
ORDER BY total_orders DESC;

-- 4. Weekly indicators (RUB)
SELECT 
    DATE_TRUNC('week', created_dt_msk)::DATE AS week,
    SUM(revenue) AS total_revenue,
    COUNT(order_id) AS total_orders,
    COUNT(DISTINCT user_id) AS total_users,
    SUM(revenue) / COUNT(order_id) AS revenue_per_order
FROM afisha.purchases
WHERE currency_code = 'rub'
GROUP BY week
ORDER BY week;

-- 5. Top seven regions by revenue (RUB)
SELECT 
    r.region_name,
    SUM(p.revenue) AS total_revenue,
    COUNT(p.order_id) AS total_orders,
    COUNT(DISTINCT p.user_id) AS total_users,
    SUM(p.tickets_count) AS total_tickets,
    SUM(p.revenue) / SUM(p.tickets_count) AS one_ticket_cost
FROM 
    afisha.purchases AS p
LEFT JOIN 
    afisha.events AS e ON p.event_id = e.event_id
LEFT JOIN 
    afisha.city AS c ON e.city_id = c.city_id
LEFT JOIN 
    afisha.regions AS r ON c.region_id = r.region_id
WHERE 
    p.currency_code = 'rub'
GROUP BY 
    r.region_name
ORDER BY 
    total_revenue DESC
LIMIT 7;

-- 6. Order extract for Python
SELECT *,
    created_dt_msk::date - LAG(created_dt_msk) OVER(PARTITION BY user_id ORDER BY created_dt_msk)::date 
AS days_since_prev
FROM afisha.purchases
WHERE 
    device_type_canonical IN ('mobile', 'desktop');

-- 7. Event extract for Python
SELECT 
    e.event_id,
    e.event_name_code AS event_name,
    e.event_type_description,
    e.event_type_main,
    e.organizers, 
    r.region_name,
    c.city_name,
    c.city_id, 
    v.venue_id,
    v.venue_name,
    v.address AS venue_address
FROM afisha.events AS e
LEFT JOIN afisha.venues AS v USING(venue_id)
LEFT JOIN afisha.city AS c USING(city_id)
LEFT JOIN afisha.regions AS r USING(region_id)
WHERE 
    e.event_id IN (
        SELECT DISTINCT event_id
        FROM afisha.purchases
        WHERE device_type_canonical IN ('mobile', 'desktop')
    )
    AND e.event_type_main != 'фильм';
