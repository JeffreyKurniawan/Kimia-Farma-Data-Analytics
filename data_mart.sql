CREATE TABLE kfdataset.kf_analisa AS
SELECT
    t.transaction_id,
    t.date,
    t.branch_id,
    k.branch_name,
    k.kota,
    k.provinsi,
    k.rating AS rating_cabang,
    t.customer_name,
    p.product_id,
    p.product_name,
    p.price AS actual_price,
    t.discount_percentage,
    CASE
        WHEN p.price <= 50000 THEN 0.10
        WHEN p.price > 50000 AND p.price <= 100000 THEN 0.15
        WHEN p.price > 100000 AND p.price <= 300000 THEN 0.20
        WHEN p.price > 300000 AND p.price <= 500000 THEN 0.25
        ELSE 0.30
    END AS persentase_gross_laba,
    (p.price * (1 - t.discount_percentage)) AS nett_sales,
    (p.price * (1 - t.discount_percentage) *
    CASE
        WHEN p.price <= 50000 THEN 0.10
        WHEN p.price > 50000 AND p.price <= 100000 THEN 0.15
        WHEN p.price > 100000 AND p.price <= 300000 THEN 0.20
        WHEN p.price > 300000 AND p.price <= 500000 THEN 0.25
        ELSE 0.30
    END
    ) AS nett_profit,
    t.rating AS rating_transaksi
FROM kfdataset.kf_final_transaction AS t
LEFT JOIN
    kfdataset.kf_inventory as i ON t.branch_id = i.branch_id AND t.product_id = i.product_id
LEFT JOIN
    kfdataset.kf_kantor_cabang as k ON t.branch_id = k.branch_id
LEFT JOIN
    kfdataset.kf_product as p ON t.product_id = p.product_id;
