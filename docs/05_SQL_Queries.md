# 5. SQL-запросы для аналитики

В этом разделе представлены SQL-запросы для аналитики по заявкам и клиентам (Вариант 1 — Заявка + Клиент).

---

## 5.1 Общее количество заявок, закрытых по неподтвержденному email

Запрос считает количество заявок, которые были закрыты из-за того, что клиент не подтвердил свой email.

```sql
SELECT COUNT(*) AS closed_by_unconfirmed_email
FROM applications
WHERE status = 'CLOSED'
  AND email_confirmed = false;
```

---

## 5.2 Средний возраст клиентов, подавших заявку на кредит с суммой более 300 000 рублей, за последние полгода

Запрос вычисляет средний возраст клиентов, которые за последние 6 месяцев подали заявку на сумму больше 300 000 рублей.

```sql
SELECT AVG(EXTRACT(YEAR FROM AGE(CURRENT_DATE, c.birth_date))) AS avg_age
FROM applications a
JOIN clients c ON a.client_id = c.client_id
WHERE a.amount > 300000
  AND a.created_at >= CURRENT_DATE - INTERVAL '6 months';
```

---

## 5.3 Средний доход клиента по заявкам за месяц

**Вариант А** — доход учитывается по всем заявкам (если клиент подал несколько заявок, его доход учитывается несколько раз):

```sql
SELECT AVG(c.monthly_income) AS avg_income
FROM applications a
JOIN clients c ON a.client_id = c.client_id
WHERE a.created_at >= DATE_TRUNC('month', CURRENT_DATE)
  AND a.created_at < DATE_TRUNC('month', CURRENT_DATE) + INTERVAL '1 month';
```

**Вариант Б** — доход учитывается один раз по каждому уникальному клиенту:

```sql
SELECT AVG(monthly_income) AS avg_income
FROM (
    SELECT DISTINCT c.client_id, c.monthly_income
    FROM applications a
    JOIN clients c ON a.client_id = c.client_id
    WHERE a.created_at >= DATE_TRUNC('month', CURRENT_DATE)
      AND a.created_at < DATE_TRUNC('month', CURRENT_DATE) + INTERVAL '1 month'
) AS unique_clients;
```

---

## 5.4 Количество предложений со страховкой в разбивке по успешным и отрицательным за месяц

Запрос показывает, сколько заявок со страховкой было одобрено и сколько отклонено в текущем месяце.

```sql
SELECT 
    a.status,
    COUNT(*) AS offers_with_insurance
FROM applications a
WHERE a.with_insurance = true
  AND a.created_at >= DATE_TRUNC('month', CURRENT_DATE)
  AND a.created_at < DATE_TRUNC('month', CURRENT_DATE) + INTERVAL '1 month'
GROUP BY a.status;
```

---

## 5.5 Количество успешных предложений в разбивке по ставке

Запрос группирует одобренные заявки по процентной ставке и считает их количество.

```sql
SELECT 
    interest_rate,
    COUNT(*) AS successful_offers
FROM applications
WHERE status = 'APPROVED'
GROUP BY interest_rate
ORDER BY interest_rate;
```

---

## 5.6 Найти всех клиентов с целью кредита «покупка автомобиля»

Запрос возвращает список клиентов, которые указали цель кредита — покупка автомобиля.

```sql
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
```

---

## Полный файл с запросами

Все запросы собраны в одном SQL-файле:

- [SQL-запросы](../sql/queries.sql)
