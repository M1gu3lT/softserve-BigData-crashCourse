--------------*** VALIDAMOS SI CUENTA CON VALORES NULL ***------------
SELECT
	COUNT(*) AS null_values
FROM
bronze_layer.batch_first_load
WHERE
	person_name IS NULL
	OR user_name IS NULL
	OR email IS NULL
	OR personal_number IS NULL
	OR birth_date IS NULL
	OR address IS NULL
	OR phone_number IS NULL
	OR mac_address IS NULL
	OR ip_address IS NULL
	OR clave IS NULL
	OR accessed_at IS NULL
	OR session_duration IS NULL
	OR download_speed IS NULL
	OR upload_speed IS NULL
	OR consumer_traffic IS NULL
	OR unique_id IS NULL

------------*** VALIDA VALORES DUPLICADOS ***-------------
SELECT *,
	COUNT(*) AS duplicated_values
FROM
	bronze_layer.batch_first_load
GROUP BY (
	person_name, user_name, email, personal_number,
	birth_date, address, phone_number, mac_address, ip_address,
	clave,accessed_at, session_duration, download_speed,
	upload_speed,consumer_traffic, unique_id
	)
HAVING COUNT(*) > 1