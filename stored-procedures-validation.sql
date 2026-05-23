-- =============================================
-- Database Validation Suite
-- Module: Stored Procedures, Views, 
--         Transactions and Index Validation
-- Author: Nahlah
-- =============================================

-- =============================================
-- STORED PROCEDURES
-- =============================================

-- Procedure to validate highest paid employee
CREATE OR REPLACE PROCEDURE GET_HIGH_EARNERS
IS
BEGIN
    FOR rec IN (
        SELECT ENAME, SAL, DEPTNO
        FROM EMP
        WHERE SAL = (SELECT MAX(SAL) FROM EMP)
    )
    LOOP
        DBMS_OUTPUT.PUT_LINE(
            'Employee: ' || rec.ENAME ||
            ' | Salary: ' || rec.SAL ||
            ' | Dept: ' || rec.DEPTNO
        );
    END LOOP;
END;
/

-- Procedure to validate dept salary raise
CREATE OR REPLACE PROCEDURE VALIDATE_DEPT_RAISE(
    P_DEPTNO IN NUMBER,
    P_PERCENT IN NUMBER
)
IS
BEGIN
    UPDATE EMP
    SET SAL = SAL + (SAL * P_PERCENT / 100)
    WHERE DEPTNO = P_DEPTNO;

    DBMS_OUTPUT.PUT_LINE(
        'Salary raise of ' || P_PERCENT ||
        '% applied to DEPTNO: ' || P_DEPTNO
    );
    COMMIT;
END;
/

-- =============================================
-- VIEWS FOR QA VALIDATION
-- =============================================

-- View to validate high earners
CREATE OR REPLACE VIEW HIGH_EARNERS_VW AS
SELECT E.ENAME, E.SAL, E.JOB, D.DNAME, D.LOC
FROM EMP E
JOIN DEPT D ON E.DEPTNO = D.DEPTNO
WHERE E.SAL > 3000;

-- Validate view output
SELECT * FROM HIGH_EARNERS_VW
ORDER BY SAL DESC;

-- =============================================
-- TRANSACTION VALIDATION
-- =============================================

-- Validate salary transfer transaction
-- with rollback on failure
DECLARE
BEGIN
    SAVEPOINT BEFORE_TRANSFER;

    -- Deduct from high earner
    UPDATE EMP
    SET SAL = SAL - 500
    WHERE ENAME = 'KING';

    -- Add to low earner
    UPDATE EMP
    SET SAL = SAL + 500
    WHERE ENAME = 'SMITH';

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Transaction validated!');

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK TO BEFORE_TRANSFER;
        DBMS_OUTPUT.PUT_LINE('Transaction failed! Rolled back.');
END;
/

-- =============================================
-- INDEX VALIDATION
-- =============================================

-- Create index for performance validation
CREATE INDEX IDX_EMP_JOB ON EMP(JOB);
CREATE INDEX IDX_EMP_DEPTNO ON EMP(DEPTNO);

-- Verify indexes created
SELECT INDEX_NAME, COLUMN_NAME, TABLE_NAME
FROM USER_IND_COLUMNS
WHERE TABLE_NAME = 'EMP'
ORDER BY INDEX_
