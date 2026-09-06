
-- 5. SQL-запросы для аналитики 
-- 5.1 Общее количество заявок, закрытых по неподтвержденному email
SELECT COUNT(*) AS closed_by_unconfirmed_email
FROM applications
WHERE status = 'CLOSED'
  AND email_confirmed = false;

-- 5.2 Средний возраст клиентов, подавших заявку на сумму > 300к за последние полгода
SELECT AVG(EXTRACT(YEAR FROM AGE(CURRENT_DATE, c.birth_date))) AS avg_age
FROM applications a
JOIN clients c ON a.client_id = c.client_id
WHERE a.amount > 300000
  AND a.created_at >= CURRENT_DATE - INTERVAL '6 months';

-- 5.3 Средний доход клиента по заявкам за месяц
-- Вариант А: по всем заявкам
SELECT AVG(c.monthly_income) AS avg_income
FROM applications a
JOIN clients c ON a.client_id = c.client_id
WHERE a.created_at >= DATE_TRUNC('month', CURRENT_DATE)
  AND a.created_at < DATE_TRUNC('month', CURRENT_DATE) + INTERVAL '1 month';

-- 5.3 Вариант Б: по уникальным клиентам
SELECT AVG(monthly_income) AS avg_income
FROM (
    SELECT DISTINCT c.client_id, c.monthly_income
    FROM applications a
    JOIN clients c ON a.client_id = c.client_id
    WHERE a.created_at >= DATE_TRUNC('month', CURRENT_DATE)
      AND a.created_at < DATE_TRUNC('month', CURRENT_DATE) + INTERVAL '1 month'
) AS unique_clients;

-- 5.4 Количество предложений со страховкой (успешные/отрицательные за месяц)
SELECT 
    a.status,
    COUNT(*) AS offers_with_insurance
FROM applications a
WHERE a.with_insurance = true
  AND a.created_at >= DATE_TRUNC('month', CURRENT_DATE)
  AND a.created_at < DATE_TRUNC('month', CURRENT_DATE) + INTERVAL '1 month'
GROUP BY a.status;

-- 5.5 Количество успешных предложений в разбивке по ставке
SELECT 
    interest_rate,
    COUNT(*) AS successful_offers
FROM applications
WHERE status = 'APPROVED'
GROUP BY interest_rate
ORDER BY interest_rate;

-- 5.6 Найти всех клиентов с целью кредита «покупка автомобиля»
SELECT 
    c.client_id,
    c.last_name,
    c.first_name,
    c.email,
    c.phone,
    a.loan_purpose
FROM clients c
JOIN applications a ON c.client_id = a.client_id
WHERE a.loan_purpose = 'Покупка автомобиля';
