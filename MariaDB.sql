SELECT empno, ename, sal /*columns에 대한 조건은 SELECT */
FROM emp
WHERE empno = 7521; /* 특정 행에 대한 조건은 WHERE*/


SELECT * FROM emp WHERE sal >= 2000;

SELECT empno, ename, job FROM emp WHERE deptno = 30;

SELECT * FROM emp WHERE sal BETWEEN 1000 AND 2000; /* BEETWEEN은 이상, 이하 조건이다. 날짜도 가능하다*/
SELECT * FROM emp WHERE sal>= 1000 AND sal <= 2000;

SELECT * FROM emp WHERE hiredate BETWEEN '1981-01-01' AND '1981-12-31';

SELECT * FROM emp WHERE deptno<>30; /* 30이 아닌것*/
SELECT * FROM emp WHERE deptno IN (10,20); /* IN연산자는 10,20 중 하나에만 속하면 된다는 뜻*/

SELECT empno, ename FROM emp WHERE ename LIKE 'K%'; /* 이름이 K로 시작하는 사람*/
SELECT empno, ename FROM emp WHERE ename LIKE '%K'; /* 이름이 K로 끝나는 사람 %는 여러개 와도되고 한자리는 _인가 그렇다*/

SELECT * FROM student;

SELECT studno, NAME, tel FROM student WHERE NAME LIKE '김%'; 

# 4학년이고 학번, 이름,학년,전공1, 전공2 (4학년이면서 전공1이나 전공2가 201인 학생)

SELECT studno, NAME, grade, deptno1, deptno2 FROM student WHERE grade = 4 AND (deptno1 = 201 OR deptno2 = 201);


# 정렬은 ORDER BY
SELECT * FROM emp ORDER BY empno ASC;


# 기준은 첫 번째 꺼
SELECT * FROM emp ORDER BY sal, empno;


# emp 테이블에서 사번, 이름, job, sal, deptno 출력(deptno순, 같을때 sal 순 같을떄 사번 내림차순)
SELECT empno, ename, job, sal, deptno 
FROM emp
ORDER BY deptno, sal, empno desc;

# case 절
SELECT empno, ename,
case when deptno=10 then 'ACCOUNTINT'
     when deptno=20 then 'RESEARCH'
     when deptno=30 then 'SALES'
     when deptno=40 then 'OPERATIONS'
     ELSE 'ETC'
END AS dname
FROM emp;

/* ORDER BY랑 CASE절은 반드시 사용 방법을 외워두세요 */

# +연산을 했을때 하나가 Null이면 합이 Null이 되어버린다
SELECT empno, ename, sal+comm AS pay
FROM emp;

SELECT empno, ename, sal+comm AS pay
FROM emp
ORDER BY pay desc;

# Oracle에서의 NVL : comm이 Null이면 0으로 대체한다
SELECT empno, ename, sal+IFNULL(comm, 0) AS pay
FROM emp
ORDER BY pay DESC;

-- 문자 함수
# 문자열 n번째부터 m개 가져와라
SELECT studno, SUBSTR(NAME,1,1) FROM student;

# 특정 문자열의 위치를 가져오는 함수 INSTR
SELECT studno, tel, SUBSTR(tel,1,INSTR(tel, ')')-1) '지역번호' FROM student;

# 문자열 결합하기
SELECT CONCAT(NAME,'(',POSITION,')') name FROM professor;

# 구분자어서 결합하기 넣어주기
SELECT CONCAT_WS(' ',NAME,POSITION) name FROM professor;


SELECT ASCII('A');

# 세자리당 ,를 붙혀서 가지고 오고 싶을때
SELECT empno, NAME, format(pay,0) FROM emp2;
# 소문자로 불러오기 LOWER, UPPER
SELECT LOWER(ENAME) FROM emp;
# DB문자열을 작은 따옴표로 쓴다고...?
SELECT empno, ename, job FROM emp WHERE LOWER(job) = 'salesman';

# TRIM 앞뒤 space를 제거하는 것
SELECT '      abc       ';
SELECT TRIM('    abc     ');
SELECT LTRIM('    abc     ');
SELECT RTRIM('      abc     ');

# REPLACE
SELECT REPLACE('SQL tutorial','SQL','HTML');
SELECT REPLACE(NAME, SUBSTR(NAME,2,1), '*') FROM student;


SELECT empno AS 사번, ename AS 이름 FROM emp
ORDER BY 이름;

# 오라클에 없는건데 LEFT, RIGHT
SELECT LEFT(NAME,1) FROM student;
SELECT RIGHT(NAME, 1) FROM student;

SELECT LPAD(ename, 10, '   ') AS NAME FROM emp;
SELECT RPAD(ename, 10, '*') AS NAME FROM emp;


SELECT MOD(10,4);

-- date function
SELECT ADDDATE('2023-01-17', INTERVAL 10 DAY);
SELECT NOW(), ADDDATE(NOW(), INTERVAL -2 MONTH);
SELECT NOW(), ADDDATE(NOW(), INTERVAL 30 MINUTE);
SELECT NOW(), ADDDATE(NOW(), INTERVAL -2 HOUR);

SELECT ename, hiredate, ADDDATE(hiredate, INTERVAL 10 YEAR) 10년 FROM emp;

SELECT birthday, DATEDIFF(NOW(), birthday)/365 나이  FROM student;

-- 몇년차인지 출력
SELECT ename, hiredate,ROUND(DATEDIFF(NOW(), hiredate)/365,0) 연차 FROM emp;


SELECT DAY(NOW());
SELECT MONTH(NOW());
SELECT YEAR(NOW());

SELECT* FROM emp WHERE YEAR(hiredate)=1981;


SELECT LAST_DAY(hiredate) FROM emp;

SELECT * FROM student
WHERE MONTH(birthday) = MONTH(NOW());


SELECT EXTRACT(MONTH FROM NOW());

SELECT * FROM emp WHERE comm IS NOT NULL;

-- group function
-- COUNT NULL도 COUNT 하는데 ?
SELECT COUNT(*) FROM emp;

SELECT * FROM emp;

SELECT deptno, COUNT(*) FROM emp
GROUP BY deptno;

-- GROUPBY 의 조건은 HAVING으로 준다 **시험문제 나옴**
SELECT deptno 부서, COUNT(*), MIN(sal), MAX(sal), AVG(sal) FROM emp
GROUP BY deptno
HAVING deptno = 10;



-- professor table에서 직급별 평균 급여 출력
SELECT POSITION, AVG(PAY+IFNULL(bonus,0)) FROM professor GROUP BY POSITION HAVING POSITION = '조교수';

-- 주의 GROUP한 columns만 SELECT로 조회하는것을 권장한다.
-- GROUP BY한 colum과 그룹함수만 SELECT문에 사용한다. 논리적으로 어긋나는 경우가 많기 때문에 

SELECT POSITION, AVG(PAY+IFNULL(bonus,0)) 영끌  FROM professor 
GROUP BY POSITION
ORDER BY 영끌 DESC;


-- Oracle 서브쿼리랑 조금 다른듯 EXISTS 사용

SELECT * FROM dept
WHERE EXISTS (SELECT deptno FROM emp WHERE dept.deptno = emp.deptno);


SELECT * FROM dept
WHERE NOT EXISTS (SELECT deptno FROM emp WHERE dept.deptno = emp.deptno);




SELECT * FROM professor p
WHERE NOT EXISTS (SELECT * FROM student s WHERE p.profno = s.profno);



-- ** 이거 시험문제에 나온다고 한다 **

-- ANY 가장 작은거보다만 크면 된다 (하나보다만 ~~하면 된다)
-- > ANY : 서브쿼리의 결과 중 하나보다 크면 선택


SELECT sal FROM emp WHERE deptno=10;

SELECT empno, ename, sal FROM emp
WHERE sal > ANY (SELECT sal FROM emp WHERE deptno=10);

# 과장보다 많이받는 대리가 있나
SELECT * FROM emp2
WHERE pay >= ANY (SELECT pay FROM emp2 WHERE POSITION = '과장');

-- ALL 모든것보다 크거나 작거나
-- > ALL : 서브쿼리의 결과 모두 보다 커야 선택
SELECT empno, ename, sal FROM emp
WHERE sal >= ALL (SELECT sal FROM emp WHERE deptno=10);

SELECT * FROM emp2
WHERE pay >= ALL (SELECT pay FROM emp2 WHERE POSITION='과장');


SELECT * FROM emp2 WHERE POSITION='과장';


-- join
-- USING은 key값의 이름이 서로 같은 경우 사용
SELECT e.empno, e.ename, d.dname
FROM emp e JOIN dept d USING(deptno);

SELECT e.empno, e.ename, d.dname
FROM emp e JOIN dept d ON e.DEPTNO = d.deptno;

# alias 한번 쓰면 테이블명으로 select하지않고 alias 명으로 select 한다


-- 학생들의 학번, 이름, 학과명(제1전공) 조회

# INNER JOIN과 같다
SELECT s.studno, s.NAME, d.dname
FROM student s JOIN department d
ON s.deptno1=d.deptno;

-- 학번, 이름, 담당교수명 조회
SELECT s.studno, s.name 학생명, p.name 교수명
FROM student s LEFT JOIN professor p
USING (profno) ;

UNION # Full outer join이 따로 없다

SELECT s.studno, s.name 학생명, p.name 교수명
FROM student s RIGHT JOIN professor p
USING (profno) ;

# cross join using이나 on을 쓰지 않은거 ?
# cross join도 maria db에서 잘 안쓴다고 한다
# row가 많을수록 속도가 느려진다.
SELECT s.studno, s.name, p.name
FROM student s CROSS JOIN professor p
ON s.profno = p.profno;

SELECT s.*, p.*
FROM student s CROSS JOIN professor p
ON s.profno=p.profno;


SELECT COUNT(*) FROM student;
SELECT COUNT(*) FROM professor;

-- 학번, 이름, 학과명, 담당교수명 조회
-- ** 이것도 실기 평가에 나온다 **
SELECT s.studno, s.name, d.dname, p.name
FROM student s LEFT JOIN department d ON s.deptno1 = d.deptno
LEFT JOIN professor p ON (s.profno = p.profno);

-- 학번, 이름, 학년, 시험점수 조회
SELECT s.studno, s.name, s.grade , e.total
FROM student s LEFT JOIN exam_01 e USING(studno);

SELECT s.studno, s.name, s.grade, e.total, h.grade
FROM student s JOIN exam_01 e USING(studno)
JOIN hakjum h ON e.total BETWEEN h.min_point AND h.max_point;

-- 고객번호, 이름, 소유포인트, 삼품명
SELECT go.gno, go.gname, go.point, gi.gname
FROM gogak go JOIN gift gi
ON go.point BETWEEN gi.g_start AND gi.g_end
ORDER BY 3 DESC;

-- 노트북을 상품으로 받을 수 있는 고객의 고객번호, 이름, 포인트, 상품명 조회
SELECT go.gno, go.gname, go.point, gi.gname
FROM gogak go JOIN gift gi
ON go.point >= ALL (SELECT gi.g_start FROM gift gi WHERE gi.gname = '노트북');

-- 노트북을 상품으로 받은사람(이게 정답에 가까움)
SELECT go.gno, go.gname, go.point, gi.gname
FROM gogak go JOIN gift gi
ON gi.gname = '노트북' AND go.point >= gi.g_start
ORDER BY 3 DESC;

-- 'NEW YORK' 에서 근무하는 직원 중 커미션이 0 이거나 null인 사원의 사번, 이름, 급여, 커미션 조회
SELECT empno, ename, sal, IFNULL(e.comm,0) comm, d.LOC
FROM emp e JOIN dept d USING(deptno)
WHERE d.loc='NEW YORK' AND IFNULL(e.comm ,0)=0;

-- 컴퓨터공학과 교수가 담당하는 학생중 4학년 학생의 학번, 이름, 학년 조회
SELECT s.studno, s.name, s.grade, s.deptno1
FROM department d JOIN professor p USING(deptno)
JOIN student s USING (profno)
WHERE d.dname = '컴퓨터공학과' AND s.grade = 4;

-- emp 테이블에서 사번, 이름, 담당관리자 이름 조회
-- self join
SELECT e.empno, e.ename, m.ename
FROM emp e JOIN emp m ON e.MGR = m.empno;

-- '노트북'을 상품으로 받을 수 있는 고객의 고객번호, 이름, 포인트 조회
SELECT gno, gname, POINT
FROM gogak
WHERE POINT >= (SELECT g_start FROM gift WHERE gname = '노트북')
ORDER BY 3 DESC;

-- 서진수 학생과 제1전공이 같은 학생의 학번, 이름, 학년 조회
SELECT studno, NAME, grade, deptno1
FROM student
WHERE deptno1 = (SELECT deptno1 FROM student WHERE NAME = '서진수');

-- 최슬기 교수보다 나중에 입사한 교수의 이름, 입사일, 학과명 조회
SELECT p.NAME, p.hiredate, d.dname 
FROM professor p JOIN department d USING(deptno)
WHERE p.hiredate > (SELECT hiredate FROM professor WHERE NAME = '최슬기');

-- ver2
SELECT p.NAME, p.hiredate, d.dname 
FROM professor p JOIN department d ON p.deptno=d.deptno
WHERE p.hiredate > (SELECT hiredate FROM professor WHERE NAME = '최슬기');



-- 제1전공이 201번인 학과의 평균 몸무게보다 몸무게가 많은 학생의 이름과 몸무게 조회
SELECT NAME, weight
FROM student
WHERE weight> (SELECT AVG(weight) FROM student WHERE deptno1 = 201)
ORDER BY 2;

-- 포항본사에서 근무하는 사원의 사번, 이름 부서번호 조회
SELECT empno,NAME,deptno FROM emp2
WHERE deptno IN (SELECT dcode FROM dept2 WHERE AREA = '포항본사');

-- 체중이 2학년 학생들의 체중에서 가장 적게 나가는 학생보다 적게 나가는 학생의 이름, 학년, 체중 조회
SELECT NAME, grade, weight FROM student
WHERE weight < ALL (SELECT weight FROM student WHERE grade = 2);


-- emp2, dept2 :  각 부서별 평균 연봉을 구하고 그중에서 평균 연봉이 가장 적은 부서의 연봉보다
-- 적게 받는 직원들의 부서명, 직원이름,  연봉 조회
SELECT d.dname 부서명, e.NAME 직원이름, e.PAY 연봉 
FROM emp2 e JOIN dept2 d ON e.deptno = d.dcode
WHERE e.pay < ALL (SELECT AVG(e.pay) FROM emp2 e GROUP BY deptno)
ORDER BY 3;

-- 각 학년별 최대 몸무게를 가진 학생들의 학년과 이름과 몸무게 조회
SELECT grade, NAME, weight
FROM student
WHERE (grade, weight) IN (SELECT grade, MAX(weight) FROM student GROUP BY grade)
ORDER BY 1;

-- professor, department : 각 학과별로 입사일이 가장 오래된 교수의 교수번호, 이름, 학과명 조회
-- 입사일 오름차순으로

SELECT p.profno, p.NAME, p.hiredate, d.dname
FROM professor p JOIN department d ON p.deptno = d.deptno
WHERE (p.deptno, p.hiredate) IN (
SELECT deptno, MAX(hiredate)  FROM professor GROUP BY deptno)
ORDER BY p.hiredate ASC;



-- emp 2 : 직급별로 해당 직급에서 최대 연봉을 받는 직원의 이름과 직급, 연봉 조회. 연봉 순으로..
SELECT NAME, POSITION, pay
FROM emp2
WHERE (POSITION, pay) IN (SELECT POSITION, MAX(pay) FROM emp2 GROUP BY POSITION)
ORDER BY pay DESC;


-- DDL
CREATE TABLE ACCOUNT(
id INT PRIMARY KEY, -- int 써도 된다
NAME VARCHAR(100), -- CHAR(100)
balance INTEGER,
grade VARCHAR(10)
);

DROP TABLE ACCOUNT;

-- user table 생성
-- id int 기본키:
-- name varchar(30)
-- email varchar(30)
-- joindate date
-- address varchar(50)
-- tel varchar(14)
DROP TABLE user;

CREATE TABLE USER(
id INT NOT NULL,
NAME VARCHAR(30) NOT NULL,
email VARCHAR(30),
joindate DATE,
address VARCHAR(50),
tel VARCHAR(14),
PRIMARY KEY(id)
);

INSERT INTO user (id, NAME, email, joindate, address,tel)
VALUES(101, '홍길동','hong@kt.com',NOW(),'서울시 서초구','010-1111-2222');

INSERT INTO user
VALUES(102, '고길동','go@kt.com',NOW(),'서울시 강남구','010-1111-1111');

INSERT INTO user (id,NAME) VALUES (103,'하길동');



CREATE TABLE BOARD (
id INT AUTO_INCREMENT, -- null로 들어가면 자동으로 까진다?
title VARCHAR(30),
content VARCHAR(2000),
writedate DATE,
writer INT,
PRIMARY KEY(id),
FOREIGN KEY (writer) REFERENCES user(id));


-- 테이블 껍데기 그대로 복사하기
/* 시험에 나온다 테이블 껍데기 가져오고 조건에 맞게 채워넣기 */
CREATE TABLE emp_temp
SELECT * FROM emp WHERE 1=2;

INSERT INTO emp_temp
SELECT * FROM emp_temp WHERE comm IS NOT NULL;

CREATE TABLE emp_d10
SELECT * FROM emp WHERE deptno = 10;


CREATE TABLE emp_sub
SELECT empno, ename, hiredate FROM emp;

CREATE TABLE TRANSFER_EMP
SELECT * FROM emp WHERE 1=2;

ALTER TABLE TRANSFER_EMP
ADD tdate DATE;

INSERT INTO TRANSFER_EMP
SELECT *, NOW() FROM emp WHERE deptno=30;

DELETE FROM emp
WHERE deptno = 30;

CREATE TABLE pserons(
id INT NOT NULL UNIQUE,
NAME VARCHAR(10),
city VARCHAR2(30) DEFAULT '서울'
joindate DATE DEFAULT CURRENT_DATE()
yor CHAR(1) DEFAULT 'Y'
); -- 제약조건 여러개


CREATE TABLE pserons(
id INT NOT NULL,
NAME VARCHAR(10),
UNIQUE(id)
CHECK (age>=18)
);


CREATE TABLE pserons(
id INT NOT NULL,
NAME VARCHAR(10),
CONSTRAINT persons_id_u UNIQUE(id),
CONSTRAINT persons_age_check CHECK (age>=18)
);
-- 실기에 나온데요 ~ 테이블 3개 ? 생성 INSERT ALTER
-- 필기는 함수들이 나온다 이해하고 있으면 SOLVED 할 수 있음
-- 서브쿼리, 조인은 실기로 나온다
-- 제약조건 PRIMARY_KEY , FOREIGN_KEY, IS NOT NULL, UNIQUE

-- tuning tip 실제 중간중간에 떨어지는 ROW수가 적은형태로
SELECT AVG(e.pay) FROM emp2 e GROUP BY deptno;
SELECT gi.g_start FROM gift gi WHERE gi.gname = '노트북';
SELECT hiredate FROM professor WHERE NAME = '최슬기';
SELECT * FROM student;
SELECT * FROM exam_01;
SELECT * FROM hakjum;
SELECT * FROM gogak;
SELECT * FROM gift;
SELECT * FROM professor;
SELECT * FROM department;
SELECT * FROM emp;
SELECT * FROM dept;
SELECT * FROM dept2;
SELECT * FROM emp2;