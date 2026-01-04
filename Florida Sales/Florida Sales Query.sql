
CREATE OR REPLACE VIEW floridaRetail.table_joined AS
SELECT
    s.date,
    DAYNAME(s.date) AS                                  day_of_week,
    IF(WEEKDAY(s.date) in (5, 6), "Weekend", "Weekday") is_weekend,
    s.shop_id,
    s.shop_name,
    s.customers,
    s.sales_usd,
    s.sales_usd / s.customers as                        sales_per_customer,
    su.pct_male,
    su.pct_female,
    su.pct_family,
    su.pct_single,
    w.avg_temp_f,
    w.precip_in,
    w.is_rain,
    w.humidity_pct
FROM floridaRetail.sales s
LEFT JOIN floridaRetail.survey su
    USING (date)
LEFT JOIN floridaRetail.weather w
    USING (date);