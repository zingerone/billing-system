

INSERT INTO payment_channel (code, "name", payment_method, third_party_code, third_party_name) VALUES ('BRI_DOKU', 'BRI', 'VIRTUAL_ACCOUNT', 'DOKU01', 'DOKU');
INSERT INTO payment_channel (code, "name", payment_method, third_party_code, third_party_name) VALUES ('BRI_MIDTRANS', 'BRI', 'VIRTUAL_ACCOUNT', 'MIDTRANS01', 'MIDTRANS');




INSERT INTO "user" (id,email, hash, password, role) VALUES ('2b6551a9-ea04-4382-a128-73d349518adc', 'imam.admin@gmail.com', '73d349518adc-2b6551a9', 'admin', 'ADMIN');
INSERT INTO "user" (id, email, hash, password, role) VALUES ('3ccf6110-e6c5-40cd-9235-e55fac0563b2', 'imam.debitor@gmail.com', '73d349518adc-2b6551a9', 'debitor', 'DEBITOR');
INSERT INTO "user" (id, email, hash, password, role) VALUES ('d0d7a180-690a-4008-ad98-753e1f6b566d', 'imam.creditor@gmail.com', '73d349518adc-2b6551a9', 'creditor', 'CREDITOR');



INSERT INTO ledger (id, user_id, account_code, balance, debit, credit,currency) VALUES ('6e5629cb-662c-49f2-811c-7b41f01c8f0d', '2b6551a9-ea04-4382-a128-73d349518adc', 'CASH', 0, 0, 0, 'IDR');
INSERT INTO ledger (id, user_id, account_code, balance, debit, credit,currency) VALUES ('af342e74-66d0-49a6-b26a-869387b122b7', '2b6551a9-ea04-4382-a128-73d349518adc', 'LOAN', 0, 0, 0, 'IDR');
INSERT INTO ledger (id, user_id, account_code, balance, debit, credit,currency) VALUES ('382caad3-b5e8-4abc-8b96-35db05a03af7', '3ccf6110-e6c5-40cd-9235-e55fac0563b2', 'LOAN', 0, 0, 0, 'IDR');

INSERT INTO ledger (id, user_id, account_code, balance, debit, credit,currency) VALUES ('9bf2e856-9433-4645-bdbd-389e61ac549c', 'd0d7a180-690a-4008-ad98-753e1f6b566d', 'CASH', 0, 0, 0, 'IDR');

INSERT INTO ledger (id, user_id, account_code, balance, debit, credit,currency) VALUES ('45df9eab-80e2-4873-a83e-118ea9b14e89', 'd0d7a180-690a-4008-ad98-753e1f6b566d', 'LOAN', 0, 0, 0, 'IDR');


INSERT INTO loan(id, debitor_id, creditor_id, amount, interest_rate, total_amount, term, term_type, current_debt, status, is_delinquent) VALUES ('c4310b3c-94b6-474b-b132-b4cf9048aa00', '3ccf6110-e6c5-40cd-9235-e55fac0563b2', NULL, 1000000, 0.1, 1100000, 1, 'WEEKLY', 0, 'PENDING', FALSE);
