
CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME,@batch_start_time DATETIME, @batch_end_time DATETIME
	BEGIN TRY
	SET @batch_start_time = GETDATE();
	PRINT '====================================================================';
	PRINT 'Loading Bronze Layer';
	PRINT '====================================================================';

	PRINT '--------------------------------------------------------------------';
	PRINT 'Loading CRP Tables';
	PRINT '--------------------------------------------------------------------';

	PRINT '>>Truncating Table: bronze.crm_cust_info'
	SET @start_time = GETDATE();
	TRUNCATE TABLE bronze.crm_cust_info;
	PRINT '>>Inserting Data Into: bronze.crm_cust_info'
	BULK INSERT bronze.crm_cust_info
	FROM 'C:\Users\Admin\Downloads\sql-data-warehouse-project-main\datasets\source_crm\cust_info.csv'
	WITH (
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		TABLOCK
	);
	SET @end_time = GETDATE();
	PRINT '>> Load Duration: ' + cast (DATEDIFF(second,@start_time,@end_time) AS NVARCHAR ) +'seconds';
	PRINT '-----------------'
	--SELECT count(*) FROM bronze.crm_cust_info;

	PRINT '>>Truncating Table: bronze.crm_prd_info'
	SET @start_time = GETDATE();
	TRUNCATE TABLE bronze.crm_prd_info;
	PRINT '>>Inserting Data Into: bronze.crm_prd_info'
	BULK INSERT bronze.crm_prd_info
	FROM 'C:\Users\Admin\Downloads\sql-data-warehouse-project-main\datasets\source_crm\prd_info.csv'
	WITH (
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		TABLOCK
	);
		SET @end_time = GETDATE();
	PRINT '>> Load Duration: ' + cast (DATEDIFF(second,@start_time,@end_time) AS NVARCHAR ) +'seconds';
	PRINT '-----------------'

	--SELECT count(*) FROM bronze.crm_prd_info;
	PRINT '>>Truncating Table: bronze.crm_sales_details'
	SET @start_time = GETDATE();
	TRUNCATE TABLE bronze.crm_sales_details;
	PRINT '>>Inserting Data Into: bronze.crm_sales_details'
	BULK INSERT bronze.crm_sales_details
	FROM 'C:\Users\Admin\Downloads\sql-data-warehouse-project-main\datasets\source_crm\sales_details.csv'
	WITH (
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		TABLOCK
	);
	SET @end_time = GETDATE();
	PRINT '>> Load Duration: ' + cast (DATEDIFF(second,@start_time,@end_time) AS NVARCHAR ) +'seconds';
	PRINT '-----------------'

	--SELECT count(*) FROM bronze.crm_sales_details;

	PRINT '--------------------------------------------------------------------';
	PRINT 'Loading ERP Tables';
	PRINT '--------------------------------------------------------------------';
	PRINT '>>Truncating Table: bronze.erp_cust_az12'
	SET @start_time = GETDATE();
	TRUNCATE TABLE bronze.erp_cust_az12;
	PRINT '>>Inserting Data Into: bronze.erp_cust_az12'
	BULK INSERT bronze.erp_cust_az12
	FROM 'C:\Users\Admin\Downloads\sql-data-warehouse-project-main\datasets\source_erp\cust_az12.csv'
	WITH (
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		TABLOCK
	);
	SET @end_time = GETDATE();
	PRINT '>> Load Duration: ' + cast (DATEDIFF(second,@start_time,@end_time) AS NVARCHAR ) +'seconds';
	PRINT '-----------------'

	--SELECT count(*) FROM bronze.erp_cust_az12;

	PRINT '>>Truncating Table: bronze.erp_loc_a101'
	SET @start_time = GETDATE();
	TRUNCATE TABLE bronze.erp_loc_a101;
	PRINT '>>Inserting Data Into: bronze.erp_loc_a101'
	BULK INSERT bronze.erp_loc_a101
	FROM 'C:\Users\Admin\Downloads\sql-data-warehouse-project-main\datasets\source_erp\loc_a101.csv'
	WITH (
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		TABLOCK
	);
	SET @end_time = GETDATE();
	PRINT '>> Load Duration: ' + cast (DATEDIFF(second,@start_time,@end_time) AS NVARCHAR ) +'seconds';
	PRINT '-----------------'
	--SELECT count(*) FROM bronze.erp_loc_a101;

	PRINT '>>Truncating Table: bronze.erp_px_cat_g1v2'
	SET @start_time = GETDATE();
	TRUNCATE TABLE bronze.erp_px_cat_g1v2;
	PRINT '>>Inserting Data Into: bronze.erp_px_cat_g1v2'
	BULK INSERT bronze.erp_px_cat_g1v2
	FROM 'C:\Users\Admin\Downloads\sql-data-warehouse-project-main\datasets\source_erp\px_cat_g1v2.csv'
	WITH (
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		TABLOCK
	);
	SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + cast (DATEDIFF(second,@start_time,@end_time) AS NVARCHAR ) +'seconds';
		PRINT '-----------------'
		SET @batch_end_time = GETDATE();
		--SELECT count(*) FROM bronze.erp_px_cat_g1v2;
		PRINT '================================================================'
		PRINT 'Loading bronze layer is completed';
		PRINT '- Total Load Duration: ' + cast (DATEDIFF(second,@batch_start_time,@batch_end_time) AS NVARCHAR ) +'seconds';
		PRINT '================================================================'
	END TRY
	BEGIN CATCH
		PRINT '================================================================'
		PRINT 'ERROR OCCURRED DURING LOADING BRONZE LAYER'
		PRINT 'ERROR MESSAGE' + ERROR_MESSAGE();
		PRINT 'ERROR MESSAGE' + CAST( ERROR_NUMBER() AS NVARCHAR);
		PRINT 'ERROR MESSAGE' + CAST( ERROR_STATE() AS NVARCHAR);
		PRINT '================================================================'
	END CATCH
END