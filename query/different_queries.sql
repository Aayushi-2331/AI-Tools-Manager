SELECT 'Providers' as TableName, COUNT(*) as RowCount FROM Providers
UNION ALL SELECT 'Categories', COUNT(*) FROM Categories
UNION ALL SELECT 'Features', COUNT(*) FROM Features
UNION ALL SELECT 'UseCases', COUNT(*) FROM UseCases
UNION ALL SELECT 'Integrations', COUNT(*) FROM Integrations
UNION ALL SELECT 'Users', COUNT(*) FROM Users
UNION ALL SELECT 'Tools', COUNT(*) FROM Tools
UNION ALL SELECT 'ToolCategories', COUNT(*) FROM ToolCategories
UNION ALL SELECT 'ToolFeatures', COUNT(*) FROM ToolFeatures
UNION ALL SELECT 'PricingPlans', COUNT(*) FROM PricingPlans
UNION ALL SELECT 'ToolUseCases', COUNT(*) FROM ToolUseCases
UNION ALL SELECT 'ToolIntegrations', COUNT(*) FROM ToolIntegrations
UNION ALL SELECT 'ToolAlternatives', COUNT(*) FROM ToolAlternatives
UNION ALL SELECT 'Reviews', COUNT(*) FROM Reviews
UNION ALL SELECT 'Media', COUNT(*) FROM Media;
SELECT * FROM Tools;
SELECT tool_name, website_url FROM Tools;
SELECT * FROM Tools WHERE is_open_source = TRUE;
SELECT * FROM Tools
WHERE is_open_source = TRUE AND base_model = 'GPT-4';
SELECT * FROM Tools WHERE tool_name LIKE '%Chat%';
SELECT * FROM Tools ORDER BY release_date DESC;
SELECT * FROM Tools ORDER BY release_date DESC LIMIT 5;
INSERT INTO Users (username, email, password_hash)
VALUES ('techlover99', 'user@example.com', 'a_very_secure_hash_string');
SET SQL_SAFE_UPDATES=0;
UPDATE Tools
SET description = 'A family of large language models.'
WHERE tool_name = 'ChatGPT';
DELETE FROM PricingPlans
WHERE plan_name = 'Obsolete Plan' AND tool_id = 1;
SELECT
    Tools.tool_name,
    Providers.provider_name
FROM
    Tools
INNER JOIN Providers ON Tools.provider_id = Providers.provider_id;
SELECT
    t.tool_name,
    r.rating,
    r.review_body
FROM
    Tools t
LEFT JOIN Reviews r ON t.tool_id = r.tool_id;
SELECT
    t.tool_name
FROM
    Tools t
INNER JOIN ToolCategories tc ON t.tool_id = tc.tool_id
INNER JOIN Categories c ON tc.category_id = c.category_id
WHERE
    c.category_name = 'Image Generation';
    SELECT
    p.provider_name,
    COUNT(t.tool_id) AS tool_count
FROM
    Providers p
LEFT JOIN Tools t ON p.provider_id = t.provider_id
GROUP BY
    p.provider_name
ORDER BY
    tool_count DESC;
    SELECT
    t.tool_name,
    AVG(r.rating) AS average_rating
FROM
    Tools t
LEFT JOIN Reviews r ON t.tool_id = r.tool_id
GROUP BY
    t.tool_name
ORDER BY
    average_rating DESC;
    SELECT
    t.tool_name,
    AVG(r.rating) AS average_rating
FROM
    Tools t
JOIN Reviews r ON t.tool_id = r.tool_id
GROUP BY
    t.tool_name
HAVING
    AVG(r.rating) >= 4.5;
    SELECT tool_name FROM Tools
WHERE tool_id IN (
    SELECT tool_id FROM PricingPlans WHERE plan_name = 'Free'
);
START TRANSACTION;

-- Insert the new user
INSERT INTO Users (username, email, password_hash)
VALUES ('new_reviewer', 'reviewer@test.com', 'hash123');

-- Insert their review
SET SQL_SAFE_UPDATES=0;
ALTER TABLE Reviews MODIFY user_id INT NULL;

INSERT INTO Reviews (tool_id, user_id, rating, review_title)
VALUES (1, NULL, 5, 'Amazing!');

COMMIT;
START TRANSACTION ;

INSERT INTO Users (username, email, password_hash)
VALUES ('another_user', 'another@test.com', 'hash456');

ROLLBACK;
ALTER TABLE Users
ADD COLUMN is_verified BOOLEAN DEFAULT FALSE;
CREATE VIEW v_ToolRatings AS
SELECT
    t.tool_name,
    AVG(r.rating) AS average_rating,
    COUNT(r.review_id) AS review_count
FROM
    Tools t
LEFT JOIN Reviews r ON t.tool_id = r.tool_id
GROUP BY
    t.tool_name;

-- Now you can just query the view:
SELECT * FROM v_ToolRatings WHERE average_rating > 4.0;

GRANT SELECT ON Tools TO 'root'@'localhost';

-- Take that permission away
REVOKE SELECT ON Tools FROM 'root'@'localhost';
