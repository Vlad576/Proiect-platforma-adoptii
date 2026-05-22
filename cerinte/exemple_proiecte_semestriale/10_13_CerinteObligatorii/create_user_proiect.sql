CREATE USER proiect IDENTIFIED BY proiect;

GRANT DBA TO proiect;

--pentru a acorda privilegii
--GRANT CREATE SESSION TO proiect;

-- spatiu nelimitat pe tablespace-ul USERS
ALTER USER proiect QUOTA UNLIMITED ON users;


-- TABLESPACES disponibile
/*
SELECT tablespace_name, status, contents, block_size,
       ROUND(max_size_mb) AS max_size_mb
FROM (
    SELECT t.tablespace_name,
           t.status,
           t.contents,
           t.block_size,
           SUM(d.maxbytes) / 1024 / 1024 AS max_size_mb
    FROM   dba_tablespaces t
    JOIN   dba_data_files  d ON d.tablespace_name = t.tablespace_name
    GROUP  BY t.tablespace_name, t.status, t.contents, t.block_size
)
ORDER  BY tablespace_name;


-- Privilegii de sistem acordate rolului DBA
SELECT privilege, admin_option
FROM   dba_sys_privs
WHERE  grantee = 'DBA'
ORDER  BY privilege;

-- Privilegii pe obiecte acordate rolului DBA
SELECT owner, table_name, privilege, grantable
FROM   dba_tab_privs
WHERE  grantee = 'DBA'
ORDER  BY owner, table_name, privilege;

-- Roluri acordate rolului DBA (roluri imbricate)
SELECT granted_role, admin_option, default_role
FROM   dba_role_privs
WHERE  grantee = 'DBA'
ORDER  BY granted_role;


SELECT privilege, admin_option
FROM   dba_sys_privs
WHERE  grantee = 'DBA'
ORDER  BY privilege;
*/