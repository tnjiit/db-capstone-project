## Introduction

As a part of *Meta's Coursera Database Engineering Course*, this is the capstone project. The project is expected to span 4 weeks.<br/>
The project includes:
1. Week 1
    1. Setup the database and *MySQL* server.
    2. Create and implement and Entity Relationship (*ER*) diagram.
        1. Ensure that ER diagram conforms to 3NF. - This helps in avoiding the *insertion, update and delete* anamolies.
        2. Use *MySQL Workbench* for the diagram and generate *sql query* using *Forward Engineering*. MySQL Workbench is a visual tool for database modelling and data management. Via Forward Engineering MySQL Workbench allows us to transform the data model into a physical database schema.
    3. Setting up version control via *Git* and setting up *GitHub* for project management and publication.

Through this document, I expect to track my progress in the project.

## Glossary:

#### MARKDOWN

| Font Type | My Usage | Looks |
| :--- | :--- | :--- |
| Italics | For the first instance of term in the document | _italics_, *italics* |
| Bold | For actions |  __bold__, **bold** |
| Highlight | TBD | `highlight` |

## Release Notes

### 1st September 2023


#### Week Overview

Need to set up a booking system to keep track of which guests are visiting the restaurant and at what times.<br/>

##### Stage 1

- Set up a repository, or local directory to house your code.
- Record all changes made within the system as they’re implemented.
- And allow others to view, review and add to your code.

##### Stage 2

- Create a new user account and grant privileges.
- Connect server to the MySQL WOrkbench.

##### Stage 3

- Create a normalized (3NF) ER Model for LittleLemon.
- Create queries to generate the model.


#### Implementation

* __Installed__ the requirements:
    1. *MySQL* server: __Downloaded__ via *brew*.
    1. *MySQL Workbench* : __Downloaded__ via *dev.mysql.com/downloads*.
    1.  Git: __Downloaded__ via *brew*.
* __Added__ *requirements.txt* for python dependencies in the project.
* __Added__ *.gitignore* and *README.md* and setup the git repository.
* __Setup__ github/git: https://github.com/tnjiit/db-capstoneo-project
* __Setup__ a new user for MySQL server and granted privilages.
    - __Created__ a new user:

        > mysql -uroot -p*PASSWORD* -e " CREATE USER \'*NEW_USERNAME*\'@\'localhost\' IDENTIFIED BY \'*NEW_PASSWORD*\' ; "

    - __Confirmed__ creation of new user:

        > mysql -uroot -p*PASSWORD* -e " SELECT * FROM mysql.user; "

    - Privilages for *NEW_USERNAME* before any grants:

        > mysql -uroot -p*PASSWORD* -e " SHOW GRANTS FOR \'*NEW_USERNAME*\'@\'localhost\' ; "

        > +----------------------------------------------------+

        > | Grants for *NEW_USERNAME*@localhost                |

        > +----------------------------------------------------+

        > | GRANT USAGE ON *.* TO \`*NEW_USERNAME*\`@\`localhost\` |

        > +----------------------------------------------------+


    - __Set__ the new previlates for *NEW_USERNAME*

        > mysql -uroot -p*PASSWORD* -e " GRANT ALL PRIVILEGES ON *.* TO \'*NEW_USERNAME*\'@\'localhost\' WITH GRANT OPTION ; "

        > mysql -uroot -p*PASSWORD* -e " SHOW GRANTS FOR \'*NEW_USERNAME*\'@\'localhost\' ; "

        > +----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

        > | Grants for *NEW_USERNAME*@localhost                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |

        > +----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

        > | GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, RELOAD, SHUTDOWN, PROCESS, FILE, REFERENCES, INDEX, ALTER, SHOW DATABASES, SUPER, CREATE TEMPORARY TABLES, LOCK TABLES, EXECUTE, REPLICATION SLAVE, REPLICATION CLIENT, CREATE VIEW, SHOW VIEW, CREATE ROUTINE, ALTER ROUTINE, CREATE USER, EVENT, TRIGGER, CREATE TABLESPACE, CREATE ROLE, DROP ROLE ON *.* TO \`*NEW_USERNAME*\`@\`localhost\` WITH GRANT OPTION                                                                                                                                                                                                                                                                                                                                                                                     |

        > | GRANT APPLICATION_PASSWORD_ADMIN,AUDIT_ABORT_EXEMPT,AUDIT_ADMIN,AUTHENTICATION_POLICY_ADMIN,BACKUP_ADMIN,BINLOG_ADMIN,BINLOG_ENCRYPTION_ADMIN,CLONE_ADMIN,CONNECTION_ADMIN,ENCRYPTION_KEY_ADMIN,FIREWALL_EXEMPT,FLUSH_OPTIMIZER_COSTS,FLUSH_STATUS,FLUSH_TABLES,FLUSH_USER_RESOURCES,GROUP_REPLICATION_ADMIN,GROUP_REPLICATION_STREAM,INNODB_REDO_LOG_ARCHIVE,INNODB_REDO_LOG_ENABLE,PASSWORDLESS_USER_ADMIN,PERSIST_RO_VARIABLES_ADMIN,REPLICATION_APPLIER,REPLICATION_SLAVE_ADMIN,RESOURCE_GROUP_ADMIN,RESOURCE_GROUP_USER,ROLE_ADMIN,SENSITIVE_VARIABLES_OBSERVER,SERVICE_CONNECTION_ADMIN,SESSION_VARIABLES_ADMIN,SET_USER_ID,SHOW_ROUTINE,SYSTEM_USER,SYSTEM_VARIABLES_ADMIN,TABLE_ENCRYPTION_ADMIN,TELEMETRY_LOG_ADMIN,XA_RECOVER_ADMIN ON *.* TO \`*NEW_USERNAME*\`@\`localhost\` WITH GRANT OPTION |

        > +----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+


    - __Connected__ the server to the MySQL Workbench.
    - __Implemented__ the ER model. Entities include: Bookings, Orders, Delivery, Menu, Customers and Staff.
