
CREATE TYPE user_role_enum AS ENUM ('ADMIN', 'CUSTOMER_SERVICE','DEBITOR', 'CREDITOR');

CREATE TABLE "user" (
    id VARCHAR PRIMARY KEY,
    email VARCHAR(50) NOT NULL UNIQUE,
    hash VARCHAR NOT NULL,
    password VARCHAR NOT NULL,
    role user_role_enum NOT NULL,
    is_active BOOLEAN DEFAULT TRUE NOT NULL,
    created_at_utc TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at_utc TIMESTAMP DEFAULT NULL
);


CREATE TYPE account_code_enum AS ENUM ('LOAN', 'CASH');
CREATE TABLE ledger (
    id VARCHAR PRIMARY KEY,
    user_id VARCHAR NOT NULL,
    account_code account_code_enum NOT NULL,
    balance DECIMAL(10, 2) DEFAULT 0 NOT NULL,
    debit DECIMAL(10, 2) DEFAULT 0 NOT NULL,
    credit DECIMAL(10, 2) DEFAULT 0 NOT NULL,
    currency VARCHAR(3) DEFAULT 'IDR' NOT NULL,
    created_at_utc TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at_utc TIMESTAMP DEFAULT NULL,
    FOREIGN KEY (user_id) REFERENCES "user"(id)
);




CREATE TYPE ledger_transaction_type_enum AS ENUM ('DEBIT', 'CREDIT');
CREATE TABLE ledger_transaction (
    id VARCHAR PRIMARY KEY,
    ledger_id VARCHAR NOT NULL,
    amount DECIMAL(10, 2) DEFAULT 0 NOT NULL,
    transaction_type ledger_transaction_type_enum NOT NULL,
    created_at_utc TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at_utc TIMESTAMP DEFAULT NULL,
    FOREIGN KEY (ledger_id) REFERENCES ledger(id)
);


CREATE Type loan_term_type_enum AS ENUM ('MONTHLY', 'WEEKLY', 'DAILY');
CREATE Type loan_status_enum AS ENUM ('APPROVED', 'REJECTED', 'PENDING','DRAFT');

CREATE TABLE loan (
    id VARCHAR PRIMARY KEY,
    debitor_id VARCHAR NOT NULL,
    creditor_id VARCHAR DEFAULT NULL,
    amount DECIMAL(10, 2) DEFAULT 0 NOT NULL,
    interest_rate DECIMAL(5, 2) NOT NULL,
    total_amount DECIMAL(10, 2) DEFAULT 0 NOT NULL,
    term INT NOT NULL DEFAULT 1,
    term_type loan_term_type_enum DEFAULT 'WEEKLY',
    current_debt DECIMAL(10, 2) DEFAULT 0 NOT NULL,
    status loan_status_enum DEFAULT 'PENDING',   
    is_delinquent BOOLEAN DEFAULT FALSE NOT NULL,
    created_at_utc TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at_utc TIMESTAMP DEFAULT NULL,  
    approval_id VARCHAR,
    approved_at_utc TIMESTAMP,
    FOREIGN KEY (creditor_id) REFERENCES "user"(id),
    FOREIGN KEY (debitor_id) REFERENCES "user"(id),
    FOREIGN KEY (approval_id) REFERENCES "user"(id)
);


CREATE TABLE loan_delinquent_history (
    id VARCHAR PRIMARY KEY,
    loan_id VARCHAR NOT NULL,
    remark TEXT,
    created_at_utc TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at_utc TIMESTAMP DEFAULT NULL,
    FOREIGN KEY (loan_id) REFERENCES loan(id)
);

create type installment_status_enum AS ENUM ('DRAFT','PENDING', 'PAID', 'OVERDUE');

CREATE TABLE installment (
    id VARCHAR PRIMARY KEY,
    loan_id VARCHAR NOT NULL,
    period INT NOT NULL DEFAULT 1,
    amount DECIMAL(10, 2) DEFAULT 0 NOT NULL,
    status installment_status_enum DEFAULT 'PENDING',
    start_date_utc TIMESTAMP NOT NULL,
    due_date_utc TIMESTAMP NOT NULL,
    created_at_utc TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at_utc TIMESTAMP DEFAULT NULL,
    FOREIGN KEY (loan_id) REFERENCES loan(id)
);

CREATE TYPE payment_type_enum AS ENUM ('INSTALLMENT', 'FULL_PAYMENT','PARTIAL_PAYMENT');
CREATE TYPE payment_method_enum AS ENUM ('CASH', 'BANK_TRANSFER', 'CREDIT_CARD','VIRTUAL_ACCOUNT');



CREATE TABLE payment_channel (
    code VARCHAR PRIMARY KEY,
    "name" VARCHAR(50) NOT NULL,
    payment_method payment_method_enum NOT NULL,
    third_party_code VARCHAR(50) NOT NULL,
    third_party_name VARCHAR(50) NOT NULL,
    created_at_utc TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at_utc TIMESTAMP DEFAULT NULL
);



CREATE TABLE payment (
    id VARCHAR PRIMARY KEY,
    installment_id VARCHAR NOT NULL,
    amount DECIMAL(10, 2) DEFAULT 0 NOT NULL,
    payment_method payment_method_enum DEFAULT 'VIRTUAL_ACCOUNT',
    payment_channel_code  VARCHAR,
    metadata JSONB DEFAULT '{}',
    metadata_output JSONB DEFAULT '{}',
    paid_at_utc TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_at_utc TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at_utc TIMESTAMP DEFAULT NULL,
    FOREIGN KEY (installment_id) REFERENCES installment(id),
    FOREIGN KEY (payment_channel_code) REFERENCES payment_channel(code)
);