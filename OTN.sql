CREATE DATABASE OrganTransplantationNetwork;
USE OrganTransplantationNetwork;
CREATE TABLE Patients (
    PatientID INT AUTO_INCREMENT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Gender ENUM('Male', 'Female', 'Other'),
    BirthDate DATE,
    BloodType ENUM('A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'),
    OrganNeeded VARCHAR(50),
    PriorityLevel INT,
    RegistrationDate DATE
);
CREATE TABLE Donors (
    DonorID INT AUTO_INCREMENT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Gender ENUM('Male', 'Female', 'Other'),
    BirthDate DATE,
    BloodType ENUM('A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'),
    OrganDonated VARCHAR(50),
    DonationDate DATE
);
CREATE TABLE Transplants (
    TransplantID INT AUTO_INCREMENT PRIMARY KEY,
    PatientID INT,
    DonorID INT,
    OrganTransplanted VARCHAR(50),
    TransplantDate DATE,
    HospitalName VARCHAR(100),
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID),
    FOREIGN KEY (DonorID) REFERENCES Donors(DonorID)
);
INSERT INTO Patients (FirstName, LastName, Gender, BirthDate, BloodType, OrganNeeded, PriorityLevel, RegistrationDate)
VALUES 
('John', 'Doe', 'Male', '1980-05-15', 'O+', 'Kidney', 1, '2023-01-01'),
('Jane', 'Smith', 'Female', '1975-07-20', 'A+', 'Liver', 2, '2023-02-15'),
('Jim', 'Brown', 'Male', '1990-10-10', 'B+', 'Heart', 3, '2023-03-10');
INSERT INTO Donors (FirstName, LastName, Gender, BirthDate, BloodType, OrganDonated, DonationDate)
VALUES 
('Alice', 'Johnson', 'Female', '1985-12-25', 'O+', 'Kidney', '2023-04-01'),
('Bob', 'Davis', 'Male', '1970-03-05', 'A+', 'Liver', '2023-04-15'),
('Charlie', 'Wilson', 'Male', '1992-06-15', 'B+', 'Heart', '2023-05-10');
INSERT INTO Transplants (PatientID, DonorID, OrganTransplanted, TransplantDate, HospitalName)
VALUES 
(1, 1, 'Kidney', '2023-04-05', 'General Hospital'),
(2, 2, 'Liver', '2023-04-20', 'City Hospital'),
(3, 3, 'Heart', '2023-05-15', 'County Hospital');
DELIMITER //
CREATE TRIGGER UpdatePriorityAfterTransplant
AFTER INSERT ON Transplants
FOR EACH ROW
BEGIN
    UPDATE Patients
    SET PriorityLevel = 0
    WHERE PatientID = NEW.PatientID;
END;
//
DELIMITER ;
SELECT * FROM Patients
WHERE OrganNeeded = 'Kidney';
SELECT * FROM Donors
WHERE BloodType = 'O+';
SELECT * FROM Transplants
WHERE HospitalName = 'General Hospital';
SELECT t.TransplantID, p.FirstName AS PatientFirstName, p.LastName AS PatientLastName, 
       d.FirstName AS DonorFirstName, d.LastName AS DonorLastName, 
       t.OrganTransplanted, t.TransplantDate, t.HospitalName
FROM Transplants t
JOIN Patients p ON t.PatientID = p.PatientID
JOIN Donors d ON t.DonorID = d.DonorID;