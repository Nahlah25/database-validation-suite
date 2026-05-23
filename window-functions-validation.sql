-- =============================================
-- Database Validation Suite
-- Module: Window Function Validations
-- Author: Nahlah
-- =============================================

-- Validate top 2 highest earners per department
SELECT ENAME, SAL, DEPTNO, RK
FROM (
    SELECT ENAME, SAL, DEPTNO,
    DENSE_RANK() OVER (
        PARTITION BY DEPTNO
        ORDER BY SAL DESC) AS RK
    FROM EMP
)
WHERE RK <= 2
ORDER BY DEPTNO;

-- Validate salary ranking across company
SELECT ENAME, SAL, DEPTNO,
DENSE_RANK() OVER (
    ORDER BY SAL DESC) AS COMPANY_RANK,
DENSE_RANK() OVER (
    PARTITION BY DEPTNO
    ORDER BY SAL DESC) AS DEPT_RANK
FROM EMP
ORDER BY COMPANY_RANK;

-- Validate running total of salary dept wise
SELECT ENAME, SAL, DEPTNO,
SUM(SAL) OVER (
    PARTITION BY DEPTNO
    ORDER BY SAL
    ROWS UNBOUNDED PRECEDING) AS RUNNING_TOTAL
FROM EMP
ORDER BY DEPTNO;

-- Validate previous and next salary per department
SELECT ENAME, SAL, DEPTNO,
LAG(SAL, 1, 0) OVER (
    PARTITION BY DEPTNO
    ORDER BY SAL) AS PREV_SAL,
LEAD(SAL, 1, 0) OVER (
    PARTITION BY DEPTNO
    ORDER BY SAL) AS NEXT_SAL
FROM EMP
ORDER BY DEPTNO;

-- Validate salary quartiles
SELECT ENAME, SAL,
NTILE(4) OVER (
    ORDER BY SAL) AS QUARTILE
FROM EMP
ORDER BY QUARTILE;

-- Validate 3rd highest salary
SELECT SAL AS THIRD_HIGHEST
FROM (
    SELECT SAL,
    DENSE_RANK() OVER (
        ORDER BY SAL DESC) AS RK
    FROM EMP
)
WHERE RK = 3;
