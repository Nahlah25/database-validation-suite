-- =============================================
-- Database Validation Suite
-- Module: Subquery Validations for QA Testing
-- Author: Nahlah
-- =============================================

-- Verify employees earning above company average
SELECT E.ENAME, E.SAL, E.DEPTNO
FROM EMP E
WHERE E.SAL > (SELECT AVG(SAL) FROM EMP)
ORDER BY E.SAL DESC;

-- Validate each employee salary vs department average
SELECT E1.ENAME,
       E1.SAL,
       E1.DEPTNO,
       ROUND((SELECT AVG(SAL)
        FROM EMP E2
        WHERE E2.DEPTNO = E1.DEPTNO), 2) AS DEPT_AVG,
       E1.SAL - (SELECT AVG(SAL)
        FROM EMP E2
        WHERE E2.DEPTNO = E1.DEPTNO) AS DIFFERENCE
FROM EMP E1
ORDER BY E1.DEPTNO;

-- Verify departments with no employees
SELECT D.DNAME, D.LOC
FROM DEPT D
WHERE NOT EXISTS (
    SELECT 1 FROM EMP E
    WHERE E.DEPTNO = D.DEPTNO
);

-- Validate highest paid employee per department
SELECT ENAME, SAL, DEPTNO
FROM EMP
WHERE SAL IN (
    SELECT MAX(SAL)
    FROM EMP
    GROUP BY DEPTNO
)
ORDER BY DEPTNO;

-- Verify employees hired same year as their manager
SELECT E.ENAME, E.HIREDATE, E.MGR
FROM EMP E
WHERE TO_CHAR(E.HIREDATE, 'YYYY') = (
    SELECT TO_CHAR(M.HIREDATE, 'YYYY')
    FROM EMP M
    WHERE M.EMPNO = E.MGR
);
