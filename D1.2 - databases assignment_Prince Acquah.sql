--Q. 1
SELECT COUNT(u_id) FROM users;

--Q. 2
SELECT  COUNT(transfer_id) FROM transfers
WHERE send_amount_currency='CFA';


--Q. 3
SELECT COUNT (u_id)
FROM transfers WHERE send_amount_currency='CFA' ;


--Q. 4
SELECT COUNT(atx_id) 
FROM agent_transactions
WHERE EXTRACT(YEAR FROM when_created)='2018'
GROUP BY EXTRACT(MONTH FROM when_created);


--Q. 5
WITH agentwithdrawers AS
(SELECT COUNT(agent_id) 
AS netwithdrawers 
FROM agent_transactions
HAVING COUNT(amount) 
IN (SELECT COUNT(amount) FROM agent_transactions WHERE amount > -1
AND amount !=0 HAVING COUNT (amount)>(SELECT COUNT (amount)
FROM agent_transactions WHERE amount < 1 AND amount !=0)))
SELECT netwithdrawers FROM agentwithdrawers;


--Q. 6
SELECT COUNT(atx.amount) AS "atx volume city summary" , ag.city
FROM agent_transactions AS atx LEFT OUTER JOIN agents AS ag ON
atx.atx_id = ag.agent_id
WHERE atx.when_created BETWEEN NOW()::DATE-EXTRACT(DOW FROM NOW())::INTEGER-7
AND NOW()::DATE-EXTRACT(DOW FROM NOW())::INTEGER
GROUP BY ag.city


--Q. 7
SELECT City, Volume, Country 
FROM ( Select agents.city AS City, agents.country 
AS Country, count(agent_transactions.atx_id) 
AS Volume FROM agents INNER JOIN agent_transactions 
ON agents.agent_id = agent_transactions.agent_id where (agent_transactions.when_created > (NOW() - INTERVAL '1 week')) 
GROUP BY agents.country,agents.city) as atx_volume_summary_with_Country;


--Q. 8 
SELECT transfers.kind AS Kind, wallets.ledger_location 
AS Country, sum(transfers.send_amount_scalar) 
AS Volume FROM transfers 
INNER JOIN wallets ON transfers.source_wallet_id = wallets.wallet_id where (transfers.when_created > (NOW() - INTERVAL '1 week')) 
GROUP BY wallets.ledger_location, transfers.kind;

--Q. 9
SELECT COUNT(transfers.source_wallet_id) 
AS Unique_Senders, 
COUNT (transfer_id) 
AS Transaction_Count, transfers.kind 
AS Transfer_Kind, wallets.ledger_location 
AS Country, 
SUM (transfers.send_amount_scalar) 
AS Volume 
FROM transfers 
INNER JOIN wallets 
ON transfers.source_wallet_id = wallets.wallet_id 
WHERE (transfers.when_created > (NOW() - INTERVAL '1 week')) 
GROUP BY wallets.ledger_location, transfers.kind; 

--Q. 10 
SELECT source_wallet_id, send_amount_scalar 
FROM transfers WHERE send_amount_currency = 'CFA' 
AND (send_amount_scalar>10000000) 
AND (transfers.when_created > (NOW() - INTERVAL '1 month'));