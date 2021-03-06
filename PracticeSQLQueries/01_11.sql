-- Year over Year Calculations
USE AdventureWorksDW2014;
GO

-- Get Prev Year Sales
WITH MonthlySales (YearNum, MonthNum, Sales)
AS
(
	SELECT d.CalendarYear, d.MonthNumberOfYear, SUM(s.SalesAmount) 
	FROM DimDate d
	JOIN FactInternetSales s ON d.DateKey = s.OrderDateKey
	GROUP BY d.CalendarYear, d.MonthNumberOfYear
)
-- Get Current Year and join to CTE for previous year
SELECT 
		d.CalendarYear
	,	d.MonthNumberOfYear
	,	ms.Sales PrevSales
	,	SUM(s.SalesAmount) CurrentSales
FROM DimDate d
JOIN FactInternetSales s ON d.DateKey = s.OrderDateKey
JOIN MonthlySales ms ON 
	d.CalendarYear-1 = ms.YearNum AND
	d.MonthNumberOfYear = ms.MonthNum
GROUP BY
		d.CalendarYear
	,	d.MonthNumberOfYear
	,	ms.Sales
ORDER BY
		1 DESC, 2 DESC


-- Now calculate the % change Year over Year
WITH MonthlySales (YearNum, MonthNum, Sales)
AS
(
	SELECT d.CalendarYear, d.MonthNumberOfYear, SUM(s.SalesAmount) 
	FROM DimDate d
	JOIN FactInternetSales s ON d.DateKey = s.OrderDateKey
	GROUP BY d.CalendarYear, d.MonthNumberOfYear
)
-- Get Current Year and join to CTE for previous year
SELECT 
		d.CalendarYear
	,	d.MonthNumberOfYear
	,	ms.Sales PrevSales
	,	SUM(s.SalesAmount) CurrentSales
	,	(SUM(s.SalesAmount) - ms.Sales) / SUM(s.SalesAmount) 'PctGrowth'
FROM DimDate d
JOIN FactInternetSales s ON d.DateKey = s.OrderDateKey
JOIN MonthlySales ms ON 
	d.CalendarYear-1 = ms.YearNum AND
	d.MonthNumberOfYear = ms.MonthNum
GROUP BY
		d.CalendarYear
	,	d.MonthNumberOfYear
	,	ms.Sales
ORDER BY
		1 DESC, 2 DESC