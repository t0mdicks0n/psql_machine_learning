CREATE LANGUAGE plpython3u;
DROP TABLE IF EXISTS wine_sample;
-- Create the table
CREATE TABLE wine_sample ( 
	id serial,
	fixed_acidity float8,
	volatile_acidity float8,
	citric_acid float8,
	residual_sugar float8,
	chlorides float8,
	free_sulfur_dioxide float8,
	total_sulfur_dioxide float8,
	density float8,
	ph float8,
	sulphates float8,
	alcohol float8,
	quality float8
);
-- Copy in the data from the csv file to psql
copy wine_sample(
	fixed_acidity,
	volatile_acidity,
	citric_acid,
	residual_sugar,
	chlorides,
	free_sulfur_dioxide,
	total_sulfur_dioxide,
	density,
	ph,
	sulphates,
	alcohol,
	quality
) from '/tmp/wine_data/winequality-red.csv' WITH DELIMITER ';' CSV HEADER;