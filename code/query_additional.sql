-- Query to find investors with no financial goals
SELECT i.Phone, i.Name
FROM INVESTOR i
LEFT JOIN FINANCIAL_GOAL fg ON i.Phone = fg.Phone
WHERE fg.Phone IS NULL
ORDER BY i.Name;