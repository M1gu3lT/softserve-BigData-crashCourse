----------*** CREACION DE TABLA golden_layer.payment_data ***------------
CREATE TABLE
	golden_layer.payment_data AS
SELECT
	fnu.unique_id,
	df.clabe,
	fnu.download_speed,
	fnu.upload_speed,
	fnu.session_duration,
	fnu.consumed_traffic,
	((fnu.download_speed + fnu.upload_speed + 1)/2) +
	(fnu.consumed_traffic / (fnu.session_duration + 1)) AS payment_amount
FROM
	silver_layer.fact_network_usage fnu
JOIN
	silver_layer.dim_finance df
ON
	fnu.unique_id = df.unique_id

	SELECT
		*
	FROM
		golden_layer.payment_data
	LIMIT 10
----------*** CREACION DE TABLA golden_layer.technical_data ***------------
CREATE TABLE
	golden_layer.technical_data AS
SELECT
	fnu.unique_id,
	da.address,
	da.mac_address,
	da.ip_address,
	fnu.download_speed,
	fnu.upload_speed,
	ROUND((fnu.session_duration/60), 1) as min_session_duration,
	CASE
	 WHEN fnu.download_speed < 50 OR fnu.upload_speed < 30 OR
		fnu.session_duration/60 < 1 THEN true
	 ELSE false
	 END AS technical_issue
FROM
	silver_layer.fact_network_usage fnu
JOIN
	silver_layer.dim_address da
ON
	fnu.unique_id = da.unique_id

SELECT
	*
FROM
	golden_layer.technical_data
LIMIT 10
----------*** CREACION DE TABLA golden_layer.non_pii_data ***------------
CREATE TABLE
golden_layer.non_pii_data AS
SELECT
'***MASKED***' AS person_name,
SUBSTRING(dp.user_name, 1, 5) || '*****' user_name,
SUBSTRING(dp.email, 1, 5) || '*****' AS email,
'***MASKED***' AS personal_number,
'***MASKED***' AS birth_date,
'***MASKED***' AS address,
'***MASKED***' AS phone,
SUBSTRING(da.mac_address, 1, 5) || '*****' AS mac_address,
SUBSTRING(da.ip_address, 1, 5) || '*****' AS ip_address,
SUBSTRING(df.clave, 1, 5) || '*****' AS iban,
dd.accessed_at,
fnu.session_duration,
fnu.download_speed,
fnu.upload_speed,
fnu.consumer_traffic,
fnu.unique_id
FROM
silver_layer.fact_network_usage fnu
INNER JOIN
silver_layer.dim_address da ON fnu.unique_id = da.unique_id
INNER JOIN
silver_layer.dim_date dd ON da.unique_id = dd.unique_id
INNER JOIN
silver_layer.dim_finance df ON dd.unique_id = df.unique_id
INNER JOIN
silver_layer.dim_person dp ON df.unique_id = dp.unique_id

SELECT
	*
FROM
	golden_layer.non_pii_data
LIMIT 10
----------*** CREACION DE TABLA golden_layer.pii_data ***------------
CREATE TABLE
golden_layer.pii_data AS
SELECT
dp.person_name,
dp.user_name,
dp.email,
dp.personal_number,
dp.birth_date,
da.address,
dp.phone_number,
da.mac_address,
da.ip_address,
df.clave,
dd.accessed_at,
fnu.session_duration,
fnu.download_speed,
fnu.upload_speed,
fnu.consumer_traffic,
fnu.unique_id
FROM
silver_layer.fact_network_usage fnu
INNER JOIN
silver_layer.dim_address da ON fnu.unique_id = da.unique_id
INNER JOIN
silver_layer.dim_date dd ON da.unique_id = dd.unique_id
INNER JOIN
silver_layer.dim_finance df ON dd.unique_id = df.unique_id
INNER JOIN
silver_layer.dim_person dp ON df.unique_id = dp.unique_id

SELECT
	*
FROM
	golden_layer.pii_data
LIMIT 10