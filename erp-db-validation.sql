-- =============================================
-- ERP Project — Database Validation Suite
-- Module: Enterprise Resource Planning
-- Author: Nahlah
-- Project: ERP Application QA Validation
-- =============================================

-- =============================================
-- EMPLOYEE VALIDATION
-- =============================================

-- Validate employee records completeness
SELECT 
    EMP_ID,
    EMP_NAME,
    EMAIL,
    DEPARTMENT,
    DESIGNATION,
    DATE_OF_JOINING,
    SALARY,
    STATUS
FROM ERP_EMPLOYEES
WHERE STATUS = 'ACTIVE'
ORDER BY DATE_OF_JOINING DESC;

-- Verify no duplicate employee emails
SELECT EMAIL, COUNT(*) AS DUPLICATE_COUNT
FROM ERP_EMPLOYEES
GROUP BY EMAIL
HAVING COUNT(*) > 1;

-- Validate employees without department
SELECT EMP_ID, EMP_NAME, EMAIL
FROM ERP_EMPLOYEES
WHERE DEPARTMENT IS NULL
OR DESIGNATION IS NULL;

-- =============================================
-- PAYROLL VALIDATION
-- =============================================

-- Verify payroll records for current month
SELECT 
    P.PAYROLL_ID,
    E.EMP_NAME,
    E.DEPARTMENT,
    P.BASIC_SALARY,
    P.ALLOWANCES,
    P.DEDUCTIONS,
    P.NET_SALARY,
    P.PAYMENT_DATE,
