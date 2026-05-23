-- =============================================
-- CRM Project — Database Validation Suite
-- Module: Customer Relationship Management
-- Author: Nahlah
-- Project: CRM Application QA Validation
-- =============================================

-- =============================================
-- TABLE STRUCTURE VALIDATION
-- =============================================

-- Validate customers table data integrity
SELECT 
    CUSTOMER_ID,
    CUSTOMER_NAME,
    EMAIL,
    PHONE,
    CITY,
    CREATED_DATE,
    STATUS
FROM CRM_CUSTOMERS
WHERE STATUS = 'ACTIVE'
ORDER BY CREATED_DATE DESC;

-- Verify no duplicate customer emails
SELECT EMAIL, COUNT(*) AS DUPLICATE_COUNT
FROM CRM_CUSTOMERS
GROUP BY EMAIL
HAVING COUNT(*) > 1;

-- Validate all required fields are not null
SELECT CUSTOMER_ID, CUSTOMER_NAME
FROM CRM_CUSTOMERS
WHERE EMAIL IS NULL
OR PHONE IS NULL
OR CUSTOMER_NAME IS NULL;

-- =============================================
-- LEADS VALIDATION
-- =============================================

-- Verify lead to customer conversion
SELECT 
    L.LEAD_ID,
    L.LEAD_NAME,
    L.LEAD_SOURCE,
    L.STATUS,
    L.ASSIGNED_TO,
    L.CREATED_DATE
FROM CRM_LEADS L
WHERE L.STATUS = 'CONVERTED'
ORDER BY L.CREATED_DATE DESC;

-- Validate lead count per sales rep
SELECT 
    ASSIGNED_TO AS SALES_REP,
    COUNT(*) AS TOTAL_LEADS,
    SUM(CASE WHEN STATUS='CONVERTED' 
        THEN 1 ELSE 0 END) AS CONVERTED,
    SUM(CASE WHEN STATUS='OPEN' 
        THEN 1 ELSE 0 END) AS OPEN_LEADS
FROM CRM_LEADS
GROUP BY ASSIGNED_TO
ORDER BY TOTAL_LEADS DESC;

-- =============================================
-- OPPORTUNITIES VALIDATION
-- =============================================

-- Verify opportunity pipeline values
SELECT 
    O.OPP_ID,
    O.OPP_NAME,
    C.CUSTOMER_NAME,
    O.DEAL_VALUE,
    O.STAGE,
    O.CLOSE_DATE
FROM CRM_OPPORTUNITIES O
JOIN CRM_CUSTOMERS C 
ON O.CUSTOMER_ID = C.CUSTOMER_ID
WHERE O.STAGE NOT IN ('CLOSED WON','CLOSED LOST')
ORDER BY O.DEAL_VALUE DESC;

-- Validate total pipeline value per stage
SELECT 
    STAGE,
    COUNT(*) AS OPP_COUNT,
    SUM(DEAL_VALUE) AS TOTAL_VALUE,
    ROUND(AVG(DEAL_VALUE), 2) AS AVG_DEAL_VALUE
FROM CRM_OPPORTUNITIES
GROUP BY STAGE
ORDER BY TOTAL_VALUE DESC;

-- =============================================
-- SUPPORT TICKETS VALIDATION
-- =============================================

-- Verify open tickets SLA breach
SELECT 
    T.TICKET_ID,
    T.SUBJECT,
    C.CUSTOMER_NAME,
    T.PRIORITY,
    T.STATUS,
    T.CREATED_DATE,
    ROUND(SYSDATE - T.CREATED_DATE) AS DAYS_OPEN
FROM CRM_SUPPORT_TICKETS T
JOIN CRM_CUSTOMERS C 
ON T.CUSTOMER_ID = C.CUSTOMER_ID
WHERE T.STATUS = 'OPEN'
AND T.PRIORITY = 'HIGH'
AND ROUND(SYSDATE - T.CREATED_DATE) > 2
ORDER BY DAYS_OPEN DESC;

-- Validate ticket resolution time
SELECT 
    PRIORITY,
    COUNT(*) AS TOTAL_TICKETS,
    ROUND(AVG(RESOLVED_DATE - CREATED_DATE), 2) 
        AS AVG_RESOLUTION_DAYS
FROM CRM_SUPPORT_TICKETS
WHERE STATUS = 'RESOLVED'
GROUP BY PRIORITY
ORDER BY AVG_RESOLUTION_DAYS;

-- =============================================
-- END TO END DATA VALIDATION
-- =============================================

-- Verify customer journey - Lead to Ticket
SELECT 
    C.CUSTOMER_NAME,
    C.EMAIL,
    L.LEAD_SOURCE,
    O.DEAL_VALUE,
    COUNT(T.TICKET_ID) AS SUPPORT_TICKETS
FROM CRM_CUSTOMERS C
LEFT JOIN CRM_LEADS L 
ON C.CUSTOMER_ID = L.CUSTOMER_ID
LEFT JOIN CRM_OPPORTUNITIES O 
ON C.CUSTOMER_ID = O.CUSTOMER_ID
LEFT JOIN CRM_SUPPORT_TICKETS T 
ON C.CUSTOMER_ID = T.CUSTOMER_ID
GROUP BY C.CUSTOMER_NAME, C.EMAIL,
         L.LEAD_SOURCE, O.DEAL_VALUE
ORDER BY O.DEAL_VALUE DESC;

-- Validate duplicate support tickets
SELECT 
    CUSTOMER_ID,
    SUBJECT,
    COUNT(*) AS DUPLICATE_COUNT
FROM CRM_SUPPORT_TICKETS
GROUP BY CUSTOMER_ID, SUBJECT
HAVING COUNT(*) > 1;
