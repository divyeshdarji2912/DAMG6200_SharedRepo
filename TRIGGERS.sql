SET SERVEROUTPUT ON;
--TRIGGER FOR LEASE_STATUS UPDATE (ONGOING OR EXPIRED)
CREATE OR REPLACE TRIGGER TRG1 
AFTER INSERT ON LEASE_DETAILS
DECLARE
    COUNT1 NUMBER;
    RECENT_LEASE_ID NUMBER;
    CURSOR COUNT_MONTHS IS SELECT MONTHS_BETWEEN(END_DATE,SYSDATE) INTO COUNT1 FROM LEASE_DETAILS;
BEGIN
      
      SELECT MAX(TO_NUMBER(SUBSTR(LEASE_ID,2))) INTO RECENT_LEASE_ID FROM LEASE_DETAILS;
      if(sql%notfound) then
        --DBMS_OUTPUT.PUT_LINE('Row has been inserted');
        OPEN COUNT_MONTHS;
            IF(COUNT1>=0) THEN 
                UPDATE LEASE_DETAILS SET LEASE_STATUS='ON GOING' WHERE LEASE_ID=CONCAT('L',TO_CHAR(RECENT_LEASE_ID));
            ELSE
                UPDATE LEASE_DETAILS SET LEASE_STATUS='EXPIRED' WHERE LEASE_ID=CONCAT('L',TO_CHAR(RECENT_LEASE_ID));
            END IF;
        CLOSE COUNT_MONTHS;
      
      else
        --DBMS_OUTPUT.PUT_LINE('Row has been inserted');
        OPEN COUNT_MONTHS;
            IF(COUNT1>=0) THEN 
                UPDATE LEASE_DETAILS SET LEASE_STATUS='ON GOING' WHERE LEASE_ID=CONCAT('L',TO_CHAR(RECENT_LEASE_ID));
            ELSE
                UPDATE LEASE_DETAILS SET LEASE_STATUS='EXPIRED' WHERE LEASE_ID=CONCAT('L',TO_CHAR(RECENT_LEASE_ID));
            END IF;
        CLOSE COUNT_MONTHS;
     end if;
END;

create or replace trigger maintenance_trigger1
after insert on maintenance_requests
declare
    id1 number;
    cls_date1 VARCHAR(50);
    cursor c1 is select request_closed_date into cls_date1 from maintenance_requests;
begin 
    
        select max(TO_NUMBER(SUBSTR(request_id,5))) into id1 from maintenance_requests;
        update maintenance_requests set maintenance_status = 'PENDING'where to_number(substr(request_id,5)) = id1;
        
end;


create or replace trigger maintenance_trigger2
after  UPDATE on maintenance_requests
BEGIN
    if updating('request_closed_date') then
    UPDATE  maintenance_requests SET  maintenance_status = 'DONE' where request_closed_date= TO_DATE(SYSDATE);
    end if ;
END;

UPDATE  MAINTENANCE_REQUESTS SET REQUEST_CLOSED_DATE='05-DEC-21' WHERE REQUEST_ID='REQ_8';
UPDATE  MAINTENANCE_REQUESTS SET REQUEST_CLOSED_DATE='05-DEC-21' WHERE REQUEST_ID='REQ_9';
INSERT INTO MAINTENANCE_REQUESTS(REQUEST_ID, APARTMENT_ID, EMPLOYEE_ID, REQUEST_DATE) VALUES ('REQ_31', 'A4', 'E8', '04-dec-21');

    
