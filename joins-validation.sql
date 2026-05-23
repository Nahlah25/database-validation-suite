
-- =============================================
-- Database Validation Suite
-- Module: JOIN Queries for QA Test Data Setup
-- Author: Nahlah
-- =============================================

-- Verify employee and department mapping
SELECT E.ENAME, E.SAL, D.DNAME, D.LOC
FROM EMP E
JOIN DEPT D ON E.DEPTNO = D.DEPTNO
ORDER BY D.DNAME;

-- Validate department wise employee count
SELECT D.DNAME, COUNT(E.EMPNO) AS EMP_COUNT
FROM DEPT D
LEFT JOIN EMP E ON D.DEPTNO = E.DEPTNO
GROUP BY D.DNAME
ORDER BY EMP_COUNT DESC;

-- Verify employee manager relationship
SELECT E1.ENAME AS EMPLOYEE,
       E1.SAL AS EMP_SAL,
       E2.ENAME AS MANAGER,
       E2.SAL AS MGR_SAL
FROM EMP E1
JOIN EMP E2 ON E1.MGR = E2.EMPNO
ORDER BY E2.ENAME;

-- Validate salary grade mapping
SELECT E.ENAME, E.SAL,
       D.DNAME, S.GRADE
FROM EMP E
JOIN DEPT D ON E.DEPTNO = D.DEPTNO
JOIN SALGRADE S ON E.SAL
BETWEEN S.LOSAL AND S.HISAL
ORDER BY S.GRADE DESC;

-- Verify employees earning more than manager
SELECT E1.ENAME AS EMPLOYEE,
       E1.SAL AS EMP_SAL,
       E2.ENAME AS MANAGER,
       E2.SAL AS MGR_SAL
FROM EMP E1
JOIN EMP E2 ON E1.MGR = E2.EMPNO
WHERE E1.SAL > E2.SAL;
