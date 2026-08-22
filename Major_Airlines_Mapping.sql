-- MAJOR AIRLINES COMPANIES - RELATIONAL MAPPING
-- Mapping from the supplied ERD/task into SQL tables

CREATE TABLE Airline (
    Airline_ID INT PRIMARY KEY,
    Name VARCHAR(150) NOT NULL,
    Address VARCHAR(250),
    Contact_Person VARCHAR(100),
    Telephone VARCHAR(30)
);

CREATE TABLE Employee (
    Employee_ID INT PRIMARY KEY,
    Airline_ID INT NOT NULL,
    Name VARCHAR(100) NOT NULL,
    Address VARCHAR(250),
    Birth_Day INT,
    Birth_Month INT,
    Birth_Year INT,
    Gender VARCHAR(20),
    Position VARCHAR(100),
    Qualifications VARCHAR(250)
);

CREATE TABLE Aircraft (
    Aircraft_ID INT PRIMARY KEY,
    Airline_ID INT NOT NULL,
    Capacity INT NOT NULL,
    Model VARCHAR(100) NOT NULL
);

CREATE TABLE Route (
    Route_ID INT PRIMARY KEY,
    Origin VARCHAR(100) NOT NULL,
    Destination VARCHAR(100) NOT NULL,
    Distance DECIMAL(10,2),
    Classification VARCHAR(30) NOT NULL
);

CREATE TABLE Crew (
    Crew_ID INT PRIMARY KEY,
    Aircraft_ID INT NOT NULL UNIQUE,
    Major_Pilot VARCHAR(100) NOT NULL,
    Assistant_Pilot VARCHAR(100) NOT NULL,
    Hostess_1 VARCHAR(100) NOT NULL,
    Hostess_2 VARCHAR(100) NOT NULL
);

CREATE TABLE Transaction_Record (
    Transaction_ID INT PRIMARY KEY,
    Airline_ID INT NOT NULL,
    Transaction_Date DATE NOT NULL,
    Description VARCHAR(250),
    Amount DECIMAL(12,2) NOT NULL,
    Transaction_Type VARCHAR(10) NOT NULL
);

-- M:N relationship: Aircraft works on Routes.
-- The following are attributes of the assignment/route operation.
CREATE TABLE Aircraft_Route (
    Aircraft_ID INT NOT NULL,
    Route_ID INT NOT NULL,
    Number_Of_Passengers INT,
    Price_Per_Passenger DECIMAL(10,2),
    Departure_Date_Time DATETIME,
    Arrival_Date_Time DATETIME,
    Travel_Time TIME,
    PRIMARY KEY (Aircraft_ID, Route_ID, Departure_Date_Time)
);

-- Foreign keys
ALTER TABLE Employee
ADD CONSTRAINT FK_Employee_Airline
FOREIGN KEY (Airline_ID) REFERENCES Airline(Airline_ID);

ALTER TABLE Aircraft
ADD CONSTRAINT FK_Aircraft_Airline
FOREIGN KEY (Airline_ID) REFERENCES Airline(Airline_ID);

ALTER TABLE Crew
ADD CONSTRAINT FK_Crew_Aircraft
FOREIGN KEY (Aircraft_ID) REFERENCES Aircraft(Aircraft_ID);

ALTER TABLE Transaction_Record
ADD CONSTRAINT FK_Transaction_Airline
FOREIGN KEY (Airline_ID) REFERENCES Airline(Airline_ID);

ALTER TABLE Aircraft_Route
ADD CONSTRAINT FK_AR_Aircraft
FOREIGN KEY (Aircraft_ID) REFERENCES Aircraft(Aircraft_ID);

ALTER TABLE Aircraft_Route
ADD CONSTRAINT FK_AR_Route
FOREIGN KEY (Route_ID) REFERENCES Route(Route_ID);
