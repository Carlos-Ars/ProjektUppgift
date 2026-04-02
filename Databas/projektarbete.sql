USE	projektarbete;

-- 1. Library först
CREATE TABLE Library (
    libraryID INT AUTO_INCREMENT PRIMARY KEY,
    address VARCHAR(150) NOT NULL
);

-- 2. Category
CREATE TABLE Category (
    categoryID INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL
);

-- 3. AccountCategory
CREATE TABLE AccountCategory (
    memberCategoryID INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    loanLimit INT NOT NULL
);

-- 4. Account
CREATE TABLE Account (
    accountID INT AUTO_INCREMENT PRIMARY KEY,
    memberCategoryID INT,
    fName VARCHAR(50),
    eName VARCHAR(50),
    email VARCHAR(100) UNIQUE,
    phoneNumber VARCHAR(20) UNIQUE,
    FOREIGN KEY (memberCategoryID)
        REFERENCES AccountCategory(memberCategoryID)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

-- 5. Item
CREATE TABLE Item (
    itemID INT AUTO_INCREMENT PRIMARY KEY,
    libraryID INT NOT NULL,
    title VARCHAR(50) NOT NULL,  
    FOREIGN KEY (libraryID) 
        REFERENCES Library(libraryID)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

-- 6. ItemCategory (måste efter Item och Category)
CREATE TABLE ItemCategory (
    itemID INT NOT NULL,
    categoryID INT NOT NULL,
    PRIMARY KEY (itemID, categoryID),
    FOREIGN KEY (itemID) 
        REFERENCES Item(itemID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (categoryID)
        REFERENCES Category(categoryID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- 7. Employee
CREATE TABLE Employee (
    employeeID INT AUTO_INCREMENT PRIMARY KEY,
    libraryID INT NOT NULL,
    fName VARCHAR(50) NOT NULL,
    eName VARCHAR(50) NOT NULL,
    epost VARCHAR(100) UNIQUE,
    phonenumber VARCHAR(20) UNIQUE,
    position VARCHAR(100),
    FOREIGN KEY (libraryID) 
        REFERENCES Library(libraryID)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

-- 8. Manager
CREATE TABLE Manager (
    employeeID INT PRIMARY KEY,
    FOREIGN KEY (employeeID) 
        REFERENCES Employee(employeeID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- 9. Copy
CREATE TABLE Copy (
    copyID INT AUTO_INCREMENT PRIMARY KEY,
    itemID INT NOT NULL,
    copyStatus VARCHAR(20),
    FOREIGN KEY (itemID)
        REFERENCES Item(itemID)
        ON DELETE CASCADE,
    CHECK (copyStatus IN ('Available', 'OnLoan', 'Lost', 'Repair'))
);

-- 10. Loan
CREATE TABLE Loan (
    loanID INT AUTO_INCREMENT PRIMARY KEY,
    copyID INT NOT NULL,
    accountID INT NOT NULL,
    loanDate DATE NOT NULL,
    returnDate DATE NOT NULL,
    itemTitle VARCHAR(100),  -- denormaliserat för snabbare joins
    FOREIGN KEY (copyID)
        REFERENCES Copy(copyID)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    FOREIGN KEY (accountID)
        REFERENCES Account(accountID)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
CHECK (loanDate <= returnDate)
);

-- 11. LoanReminder
CREATE TABLE LoanReminder (
    noticeID INT AUTO_INCREMENT PRIMARY KEY,
    loanID INT NOT NULL,
    noticeDate DATE NOT NULL,
    fineAmount DECIMAL(10,2),
    copyID INT,  -- denormaliserat för snabbare joins
    FOREIGN KEY (loanID)
        REFERENCES Loan(loanID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CHECK (fineAmount >= 0)
);

-- 12. Reservation
CREATE TABLE Reservation (
    reservationID INT AUTO_INCREMENT PRIMARY KEY,
    itemID INT NOT NULL,
    accountID INT NOT NULL,
    reservationDate DATE,
    status VARCHAR(20) NOT NULL,
    FOREIGN KEY (itemID) 
        REFERENCES Item(itemID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (accountID)
        REFERENCES Account(accountID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CHECK (status IN ('Active', 'Fulfilled', 'Cancelled'))
);

-- 13. Loantype
CREATE TABLE Loantype (
    bookTypeID INT AUTO_INCREMENT PRIMARY KEY,
    bookType VARCHAR(50) NOT NULL,
    loanPeriod INT NOT NULL,
    CHECK (loanPeriod > 0)
);

-- 14. Book
CREATE TABLE Book (
    itemID INT PRIMARY KEY,
    bookTypeID INT NOT NULL,
    ISBN CHAR(15) UNIQUE NOT NULL,
    author VARCHAR(50),
    publisher VARCHAR(50),
    totalCopies INT,
    FOREIGN KEY (itemID)
        REFERENCES Item(itemID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (bookTypeID)
        REFERENCES Loantype(bookTypeID)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

-- 15. DVD
CREATE TABLE DVD (
    itemID INT PRIMARY KEY,
    loanPeriod INT NOT NULL,
    FOREIGN KEY (itemID)
        REFERENCES Item(itemID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CHECK (loanPeriod > 0)
);

