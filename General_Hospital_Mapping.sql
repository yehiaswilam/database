-- GENERAL HOSPITAL - RELATIONAL MAPPING
-- Mapping from the supplied ERD/task into SQL tables

CREATE TABLE Ward (
    Ward_ID INT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Supervisor_Nurse_ID INT NOT NULL UNIQUE
);

CREATE TABLE Nurse (
    Nurse_ID INT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Address VARCHAR(200) NOT NULL,
    Ward_ID INT NOT NULL
);

CREATE TABLE Consultant (
    Consultant_ID INT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL
);

CREATE TABLE Patient (
    Patient_ID INT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Date_Of_Birth DATE NOT NULL,
    Ward_ID INT NOT NULL,
    Leading_Consultant_ID INT NOT NULL
);

CREATE TABLE Drug (
    Drug_Code VARCHAR(30) PRIMARY KEY,
    Recommended_Dosage VARCHAR(100) NOT NULL
);

-- Drug has more than one brand name (multivalued attribute).
CREATE TABLE Drug_Brand (
    Drug_Code VARCHAR(30) NOT NULL,
    Brand_Name VARCHAR(100) NOT NULL,
    PRIMARY KEY (Drug_Code, Brand_Name)
);

-- M:N relationship: Patient is examined by Consultants.
CREATE TABLE Patient_Consultant (
    Patient_ID INT NOT NULL,
    Consultant_ID INT NOT NULL,
    PRIMARY KEY (Patient_ID, Consultant_ID)
);

-- Ternary relationship: Nurse gives Patient a Drug,
-- with Dosage, Date and Time as relationship attributes.
CREATE TABLE Drug_Administration (
    Patient_ID INT NOT NULL,
    Nurse_ID INT NOT NULL,
    Drug_Code VARCHAR(30) NOT NULL,
    Dosage VARCHAR(100) NOT NULL,
    Administration_Date DATE NOT NULL,
    Administration_Time TIME NOT NULL,
    PRIMARY KEY (
        Patient_ID, Nurse_ID, Drug_Code,
        Administration_Date, Administration_Time
    )
);

-- Foreign keys
ALTER TABLE Nurse
ADD CONSTRAINT FK_Nurse_Ward
FOREIGN KEY (Ward_ID) REFERENCES Ward(Ward_ID);

ALTER TABLE Ward
ADD CONSTRAINT FK_Ward_Supervisor
FOREIGN KEY (Supervisor_Nurse_ID) REFERENCES Nurse(Nurse_ID);

ALTER TABLE Patient
ADD CONSTRAINT FK_Patient_Ward
FOREIGN KEY (Ward_ID) REFERENCES Ward(Ward_ID);

ALTER TABLE Patient
ADD CONSTRAINT FK_Patient_Leading_Consultant
FOREIGN KEY (Leading_Consultant_ID) REFERENCES Consultant(Consultant_ID);

ALTER TABLE Drug_Brand
ADD CONSTRAINT FK_Drug_Brand_Drug
FOREIGN KEY (Drug_Code) REFERENCES Drug(Drug_Code);

ALTER TABLE Patient_Consultant
ADD CONSTRAINT FK_PC_Patient
FOREIGN KEY (Patient_ID) REFERENCES Patient(Patient_ID);

ALTER TABLE Patient_Consultant
ADD CONSTRAINT FK_PC_Consultant
FOREIGN KEY (Consultant_ID) REFERENCES Consultant(Consultant_ID);

ALTER TABLE Drug_Administration
ADD CONSTRAINT FK_DA_Patient
FOREIGN KEY (Patient_ID) REFERENCES Patient(Patient_ID);

ALTER TABLE Drug_Administration
ADD CONSTRAINT FK_DA_Nurse
FOREIGN KEY (Nurse_ID) REFERENCES Nurse(Nurse_ID);

ALTER TABLE Drug_Administration
ADD CONSTRAINT FK_DA_Drug
FOREIGN KEY (Drug_Code) REFERENCES Drug(Drug_Code);
