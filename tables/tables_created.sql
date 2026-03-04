create schema AI;
use AI;
-- 1. Providers (The company or organization behind the tool)
CREATE TABLE Providers (
    provider_id INT PRIMARY KEY AUTO_INCREMENT,
    provider_name VARCHAR(255) NOT NULL UNIQUE,
    website VARCHAR(255),
    founded_year INT,
    headquarters_country VARCHAR(100)
);

-- 2. Tools (The core AI tool/product)
CREATE TABLE Tools (
    tool_id INT PRIMARY KEY AUTO_INCREMENT,
    tool_name VARCHAR(255) NOT NULL,
    provider_id INT,
    description TEXT,
    website_url VARCHAR(255) NOT NULL,
    release_date DATE,
    base_model VARCHAR(255), -- e.g., 'GPT-4', 'Stable Diffusion 1.5'
    is_open_source BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (provider_id) REFERENCES Providers(provider_id)
);

-- 3. Categories (Main function, e.g., 'Text Generation', 'Image Editing')
CREATE TABLE Categories (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT
);

-- 4. ToolCategories (Junction table: A tool can be in many categories)
CREATE TABLE ToolCategories (
    tool_id INT,
    category_id INT,
    PRIMARY KEY (tool_id, category_id),
    FOREIGN KEY (tool_id) REFERENCES Tools(tool_id) ON DELETE CASCADE,
    FOREIGN KEY (category_id) REFERENCES Categories(category_id) ON DELETE CASCADE
);

-- 5. Features (Specific capabilities, e.g., 'API Access', 'Browser Extension')
CREATE TABLE Features (
    feature_id INT PRIMARY KEY AUTO_INCREMENT,
    feature_name VARCHAR(255) NOT NULL UNIQUE,
    description TEXT
);

-- 6. ToolFeatures (Junction table: A tool has many features)
CREATE TABLE ToolFeatures (
    tool_id INT,
    feature_id INT,
    PRIMARY KEY (tool_id, feature_id),
    FOREIGN KEY (tool_id) REFERENCES Tools(tool_id) ON DELETE CASCADE,
    FOREIGN KEY (feature_id) REFERENCES Features(feature_id) ON DELETE CASCADE
);

-- 7. PricingPlans (The types of plans available)
CREATE TABLE PricingPlans (
    plan_id INT PRIMARY KEY AUTO_INCREMENT,
    tool_id INT,
    plan_name VARCHAR(100) NOT NULL, -- e.g., 'Free', 'Pro', 'Enterprise'
    price DECIMAL(10, 2) NOT NULL,
    billing_cycle ENUM('monthly', 'yearly', 'one-time', 'free') DEFAULT 'monthly',
    features_summary TEXT,
    FOREIGN KEY (tool_id) REFERENCES Tools(tool_id) ON DELETE CASCADE
);

-- 8. UseCases (Industries or tasks, e.g., 'Marketing', 'Software Development')
CREATE TABLE UseCases (
    use_case_id INT PRIMARY KEY AUTO_INCREMENT,
    use_case_name VARCHAR(255) NOT NULL UNIQUE
);

-- 9. ToolUseCases (Junction table: A tool has many use cases)
CREATE TABLE ToolUseCases (
    tool_id INT,
    use_case_id INT,
    PRIMARY KEY (tool_id, use_case_id),
    FOREIGN KEY (tool_id) REFERENCES Tools(tool_id) ON DELETE CASCADE,
    FOREIGN KEY (use_case_id) REFERENCES UseCases(use_case_id) ON DELETE CASCADE
);

-- 10. Users (Users of *your* database/website, who leave reviews)
CREATE TABLE Users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(100) NOT NULL UNIQUE,
    email VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    join_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 11. Reviews (User ratings and comments for tools)
CREATE TABLE Reviews (
    review_id INT PRIMARY KEY AUTO_INCREMENT,
    tool_id INT,
    user_id INT,
    rating INT NOT NULL CHECK (rating >= 1 AND rating <= 5),
    review_title VARCHAR(255),
    review_body TEXT,
    review_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (tool_id) REFERENCES Tools(tool_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE SET NULL
);

-- 12. Integrations (Other software it connects to, e.g., 'Slack', 'VS Code')
CREATE TABLE Integrations (
    integration_id INT PRIMARY KEY AUTO_INCREMENT,
    integration_name VARCHAR(100) NOT NULL UNIQUE
);

-- 13. ToolIntegrations (Junction table: A tool supports many integrations)
CREATE TABLE ToolIntegrations (
    tool_id INT,
    integration_id INT,
    PRIMARY KEY (tool_id, integration_id),
    FOREIGN KEY (tool_id) REFERENCES Tools(tool_id) ON DELETE CASCADE,
    FOREIGN KEY (integration_id) REFERENCES Integrations(integration_id) ON DELETE CASCADE
);

-- 14. ToolAlternatives (Mapping tools to their competitors/alternatives)
CREATE TABLE ToolAlternatives (
    tool_id INT,
    alternative_tool_id INT,
    PRIMARY KEY (tool_id, alternative_tool_id),
    FOREIGN KEY (tool_id) REFERENCES Tools(tool_id) ON DELETE CASCADE,
    FOREIGN KEY (alternative_tool_id) REFERENCES Tools(tool_id) ON DELETE CASCADE,
    -- Ensure a tool can't be an alternative to itself
    CHECK (tool_id != alternative_tool_id)
);

-- 15. Media (Logos, screenshots, or videos for a tool)
CREATE TABLE Media (
    media_id INT PRIMARY KEY AUTO_INCREMENT,
    tool_id INT,
    media_type ENUM('logo', 'screenshot', 'video') NOT NULL,
    media_url VARCHAR(255) NOT NULL,
    alt_text VARCHAR(255),
    FOREIGN KEY (tool_id) REFERENCES Tools(tool_id) ON DELETE CASCADE
);
