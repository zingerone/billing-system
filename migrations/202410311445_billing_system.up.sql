
CREATE TABLE user_role_enum AS ENUM ('ADMIN', 'CUSTOMER_SERVICE','DEBITOR', 'CREDITOR');

CREATE TABLE user {
    id VARCHAR PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    role user_role_enum NOT NULL,
    created_at_utc TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at_utc TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
};

CREATE TYPE account_code_enum AS ENUM ('LOAN', 'CASH');
CREATE TABLE ledger {
    id VARCHAR PRIMARY KEY,
    user_id VARCHAR NOT NULL,
    account_code account_code_enum NOT NULL,
    balance DECIMAL(10, 2) DEFAULT 0 NOT NULL,
    debit DECIMAL(10, 2) DEFAULT 0 NOT NULL,
    credit DECIMAL(10, 2) DEFAULT 0 NOT NULL,
    created_at_utc TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at_utc TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES user(id)
};


CREATE TYPE ledger_transaction_type_enum AS ENUM ('DEBIT', 'CREDIT');
CREATE TABLE ledger_transaction {
    id VARCHAR PRIMARY KEY,
    ledger_id VARCHAR NOT NULL,
    amount DECIMAL(10, 2) DEFAULT 0 NOT NULL,
    transaction_type ledger_transaction_type_enum NOT NULL,
    created_at_utc TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at_utc TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (ledger_id) REFERENCES ledger(id)
};


CREATE Type term_type_enum AS ENUM ('MONTHLY', 'WEEKLY', 'DAILY');
CREATE Type loan_status_enum AS ENUM ('APPROVED', 'REJECTED', 'PENDING','DRAFT');

CREATE TABLE loan (
    id VARCHAR PRIMARY KEY,
    debitor_id VARCHAR NOT NULL,
    creditor_id VARCHAR,
    amount DECIMAL(10, 2) DEFAULT 0 NOT NULL,
    interest_rate DECIMAL(5, 2) NOT NULL,
    total_amount DECIMAL(10, 2) DEFAULT 0 NOT NULL,
    term INT NOT NULL DEFAULT 1,
    term_type term_type_enum DEFAULT 'WEEKLY',
    current_debt DECIMAL(10, 2) DEFAULT 0 NOT NULL,
    status loan_status_enum DEFAULT 'PENDING',   
    created_at_utc TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at_utc TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,  
    approval_id VARCHAR,
    approved_at_utc TIMESTAMP,
    FOREIGN KEY (creditor_id) REFERENCES user(id),
    FOREIGN KEY (debitor_id) REFERENCES user(id),
    FOREIGN KEY (approval_id) REFERENCES user(id)
);

CREATE TABLE installment {
    id VARCHAR PRIMARY KEY,
    loan_id VARCHAR NOT NULL,
    period INT NOT NULL DEFAULT 1,
    amount DECIMAL(10, 2) DEFAULT 0 NOT NULL,
    start_date_utc TIMESTAMP NOT NULL,
    due_date_utc TIMESTAMP NOT NULL,
    created_at_utc TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at_utc TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (loan_id) REFERENCES loan(id)
}

CREATE TYPE payment_type_enum AS ENUM ('INSTALLMENT', 'FULL_PAYMENT','PARTIAL_PAYMENT');
CREATE TYPE payment_method_enum AS ENUM ('CASH', 'BANK_TRANSFER', 'CREDIT_CARD','VIRTUAL_ACCOUNT');


CREATE TABLE payment {
    id VARCHAR PRIMARY KEY,
    installment_id VARCHAR NOT NULL,
    amount DECIMAL(10, 2) DEFAULT 0 NOT NULL,
    payment_method payment_method_enum DEFAULT 'VIRTUAL_ACCOUNT',
    payment_channel_code  VARCHAR,
    paid_at_utc TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_at_utc TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at_utc TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (installment_id) REFERENCES installment(id),
    FOREIGN KEY (payment_channel_code) REFERENCES payment_channel(code)
}

CREATE TABLE payment_channel {
    code VARCHAR PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    payment_method payment_method_enum NOT NULL,
    third_party_code VARCHAR(50) NOT NULL,
    third_party_name VARCHAR(50) NOT NULL,
    created_at_utc TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at_utc TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
}

INSERT INTO payment_channel (code, name, payment_method, third_party_code, third_party_name) VALUES ('BRI_DOKU', 'BRI', 'VIRTUAL_ACCOUNT', 'DOKU01', 'DOKU');
INSERT INTO payment_channel (code, name, payment_method, third_party_code, third_party_name) VALUES ('BRI_MIDTRANS', 'BRI', 'VIRTUAL_ACCOUNT', 'MIDTRANS01', 'MIDTRANS');
