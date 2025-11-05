--1
CREATE TABLE category (
    c_categoryId SERIAL PRIMARY KEY,
    c_categoryName VARCHAR(255) NOT NULL UNIQUE,
    c_categoryDescription TEXT
);

--2
CREATE TABLE groceryitem (
    g_groceryId SERIAL PRIMARY KEY,
    g_groceryName VARCHAR(255) NOT NULL,
    g_categoryId INT[]
);

--3
CREATE TABLE household (
    h_householdId SERIAL PRIMARY KEY,
    h_ownerId INT,
    h_householdName VARCHAR(255) NOT NULL
);

--4
CREATE TABLE users (
    u_userId SERIAL PRIMARY KEY,
    u_userName VARCHAR(255) NOT NULL,
    u_householdId INT NOT NULL,
    u_isAdmin BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (u_householdId) REFERENCES household(h_householdId)
);

ALTER TABLE household
ADD CONSTRAINT h_owner FOREIGN KEY (h_ownerId) REFERENCES users(u_userId);

--5
CREATE TABLE lists (
    l_listId SERIAL PRIMARY KEY,
    l_householdId INT NOT NULL,
    l_listName VARCHAR(255),
    l_isStockList BOOLEAN DEFAULT FALSE,
    l_admin INT,
    FOREIGN KEY (l_householdId) REFERENCES household(h_householdId),
    FOREIGN KEY (l_admin) REFERENCES users(u_userId)
);

--6
CREATE TABLE entry (
    e_entryId SERIAL PRIMARY KEY,
    e_listId INT NOT NULL,
    e_groceryId INT NOT NULL,
    e_quantity INT NOT NULL,
    FOREIGN KEY (e_listId) REFERENCES lists(l_listId),
    FOREIGN KEY (e_groceryId) REFERENCES groceryitem(g_groceryId)
);
