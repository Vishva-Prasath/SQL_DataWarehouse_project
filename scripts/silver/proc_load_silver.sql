/*IN THIS WE HAVE DID THE FOLLOWING TRANSFORMATIONS:
	1. Removed unwanted spaces to ensure data consistency 
	2. Data Normalization & Standardization -- maps coded values to meaningful, user-friendly description
	3. Handling missing data -- fills in the blanks by adding default value
	4. Remove duplicates -- ensure only one record per entity by identifying and retaining the most relavent row. */
	
INSERT INTO silver.crm_cust_info
	(cst_id,
	cst_key,
	cst_firstname,
	cst_lastname,
	cst_material_status,
	cst_gender,
	cst_creation_date)
SELECT 
	cst_id,
	cst_key,
	TRIM(cst_firstname) AS cst_firstname,
	TRIM(cst_lastname) AS cst_lastname,
	CASE WHEN UPPER(TRIM(cst_material_status)) = 'S' THEN 'Single'
		 WHEN UPPER(TRIM(cst_material_status)) = 'M' THEN 'Married'
		 ELSE 'n/a'
	END  AS cst_material_status,
	CASE WHEN UPPER(TRIM(cst_gender)) = 'M' THEN 'Male'
		 WHEN UPPER(TRIM(cst_gender)) = 'F' THEN 'Female'
		 ELSE 'n/a'
	END AS cst_gender,
	cst_creation_date
FROM( 
	SELECT *,
	ROW_NUMBER () OVER (PARTITION BY cst_id ORDER BY cst_creation_date DESC) as flag_last  
	FROM bronze.crm_cust_info
	WHERE cst_id IS NOT NULL
)t WHERE flag_last = 1;




INSERT INTO silver.crm_prd_info(
	prd_id,
	cat_id,
	prd_key,
	prd_nm,
	prd_cost,
	prd_line,
	prd_start_dt,
	prd_end_dt
	)
SELECT
	prd_id,
	REPLACE(SUBSTRING(prd_key,1,5),'-','_') AS cat_id, -- SUBSTRING(column_name, starting position, how many characters needs to be extracted)
	SUBSTRING(prd_key,7,LEN(prd_key)) AS prd_key,
 	prd_nm,
	ISNULL(prd_cost,0) AS prd_cost,
	CASE UPPER(TRIM(prd_line))
		 WHEN  'M' THEN 'Mountain'
		 WHEN  'S' THEN 'Other States'
 		 WHEN  'T' THEN 'Touring'
 		 WHEN  'R' THEN 'Road'
		 ELSE 'n/a'	
	END AS prd_line, 
	CAST(prd_start_dt AS DATE) AS prd_start_dt,
	CAST(LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt)-1 AS DATE) AS prd_end_dt
FROM bronze.crm_prd_info;


SELECt * FROM silver.crm_prd_info;

DROP TABLE silver.crm_prd_info;
