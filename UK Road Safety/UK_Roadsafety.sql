/** Creating Tables*/

CREATE TABLE Accidents (
 Accident_Index	VARCHAR (200) Primary key NOT Null,
	Accident_Severity INT NOT NULL ,
	Number_of_Vehicles	INT NOT NULL,
	Road_Type	INT NOT NULL,
	Speed_limit INT NOT NULL,
	Road_Surface_Conditions	INT NOT NULL,
	Special_Conditions_at_Site INT NOT NULL,
	Weather_Conditions	INT NOT NULL,
	light_conditions INT NOT NULL
);

/** Creating Tables*/

CREATE TABLE Vehicles (
    Accident_Index VARCHAR (200) NOT NUll,
	Vehicle_Reference INT NOT NULL,
	vehicle_code INT ,
	Sex_of_Driver INT ,
	Age_of_Driver INT,
	Engine_Capacity INT,
	Age_of_Vehicle INT
);

/** Creating Tables*/

Create TABLE Vehicles_types (
vehicle_code INT NOT NULL,
vehicle_type VARCHAR (200));

/** Copying DATA*/

COPY Accidents (Accident_Index,
				Accident_Severity,
				Number_of_Vehicles,
				Road_Type,
				Speed_limit,
				Road_Surface_Conditions,
				Special_Conditions_at_Site,
				Weather_Conditions,
				light_conditions
)
FROM 'C:\\Sherif\Accidents_2015.csv'
Delimiter ';'
CSV HEADER;

/** Copying DATA*/

COPY Vehicles (Accident_Index ,
	Vehicle_Reference ,
	vehicle_code  ,
	Sex_of_Driver  ,
	Age_of_Driver ,
	Engine_Capacity ,
	Age_of_Vehicle
)
FROM 'C:\\Sherif\Vehicles_2015.csv'
Delimiter ';'
CSV HEADER;

/** Copying DATA*/

COPY Vehicles_types (
	vehicle_code  ,
	vehicle_type
)
FROM 'C:\\Sherif\Vehicles_types.csv'
Delimiter ';'
CSV HEADER;

/** Q1: Evaluate median of accident severity value of accidents caused by various Motorcycles.*/

/** Create severity_median Table*/

CREATE TABLE severity_median (
Accident_severity INT NOT NULL,
Vehicle_type VARCHAR(200));

/** Copy data*/

COPY severity_median (
	Accident_severity  ,
	vehicle_type
)
FROM 'C:\\Sherif\severity_median.csv'
Delimiter ';'
CSV HEADER;

/** Calculating severity median)*/

select Round(Avg(accident_severity),2)
from severity_median
Where vehicle_type ILIKE '%motorcycle%';
Delimiter ';'
CSV HEADER;*/


/** Q2:Evaluate Total Accidents per Vehicle Type*/

select Count (accident_severity) AS Total_Accident_per_Vehicle_type, vehicle_type
from severity_median
GROUP BY 2

/** Q3:Calculate the Average Severity by vehicle type.*/

select ROUND(AVG (accident_severity),2) AS Average_severity_per_Vehicle_type, vehicle_type
from severity_median
GROUP BY 2
