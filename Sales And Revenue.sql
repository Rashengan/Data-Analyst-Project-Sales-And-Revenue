SELECT * FROM SalesAndRevenue..SuperStore_Sales

--What is the total revenue and number of orders?
SELECT SUM(Sales) AS Total_Revenue, COUNT([Order Date]) AS OrderCount
FROM SalesAndRevenue..SuperStore_Sales

--What is the average order value (AOV) ?
SELECT SUM(Sales)/COUNT([Order ID]) AS AOV
FROM SalesAndRevenue..SuperStore_Sales

--How has monthly/yearly revenue changed over time?
SELECT FORMAT([Order Date],'yyyy-MM' ) AS Month,
SUM(Sales) AS MontlyRevenue, 
LAG(SUM(Sales)) OVER (ORDER BY FORMAT([Order Date], 'yyyy-MM')) AS Previous_Month_Sales,
SUM(Sales) - LAG(SUM(Sales)) OVER (ORDER BY FORMAT([Order Date], 'yyyy-MM')) AS Sales_Difference
FROM SalesAndRevenue..SuperStore_Sales
GROUP BY FORMAT([Order Date],'yyyy-MM' )
ORDER BY Month

--What are the top 5 best and worst performing months in terms of revenue?
SELECT TOP 5 [Product Name], SUM(Sales) AS Total_Revenue 
FROM SalesAndRevenue..SuperStore_Sales
GROUP BY [Product Name]
ORDER BY Total_Revenue DESC

SELECT TOP 5 [Product Name], SUM(Sales) AS Total_Revenue 
FROM SalesAndRevenue..SuperStore_Sales
GROUP BY [Product Name]
ORDER BY Total_Revenue ASC


--Which product generated the most revenue ?
SELECT TOP 1 [Product Name], SUM(Sales) AS Total_Revenue 
FROM SalesAndRevenue..SuperStore_Sales
GROUP BY [Product Name]
ORDER BY Total_Revenue DESC

--Which products are most and least profitable ?
SELECT TOP 1 [Product Name], SUM(Sales) AS Total_Revenue 
FROM SalesAndRevenue..SuperStore_Sales
GROUP BY [Product Name]
ORDER BY Total_Revenue ASC

-- Which cities/regionsgenerate the most revenue ?
SELECT 'Region' AS Level, Region AS Location, SUM(Sales) AS Total_Revenue
FROM SalesAndRevenue..SuperStore_Sales
GROUP BY Region

UNION ALL

SELECT 'City' AS Level, City AS Location, SUM(Sales) AS Total_Revenue
FROM SalesAndRevenue..SuperStore_Sales
GROUP BY City
ORDER BY Total_Revenue DESC

-- How does revenue differ by region over time ?(Monthly)
SELECT Region, FORMAT([Order Date],'yyyy-MM' ) AS Month, SUM(Sales) AS Total_Revenue
FROM SalesAndRevenue..SuperStore_Sales
GROUP BY Region, FORMAT([Order Date],'yyyy-MM' )
ORDER BY Month, Region;
-- How does revenue differ by region over time ?(Yearly)
SELECT Region, FORMAT([Order Date],'yyyy') AS Month, SUM(Sales) AS Total_Revenue
FROM SalesAndRevenue..SuperStore_Sales
GROUP BY Region, FORMAT([Order Date],'yyyy')
ORDER BY Month, Region;

-- Who are the most valuable customers (by total spend) ?
SELECT [Customer Name], SUM(Sales) AS Total_Revenue
FROM SalesAndRevenue..SuperStore_Sales
GROUP BY [Customer Name]

--What is the average revenue per customer segment ?
SELECT Segment, AVG(Sales) AS Total_Revenue
FROM SalesAndRevenue..SuperStore_Sales
GROUP BY Segment
ORDER BY Total_Revenue DESC

--What percentage of revenue comes from each sales channel?
SELECT [Ship Mode], SUM(Sales) AS Ship_Sales,
SUM(Sales) * 100.0 / SUM(SUM(Sales)) OVER () AS percentage_of_total
FROM SalesAndRevenue..SuperStore_Sales
GROUP BY [Ship Mode]
ORDER BY [Ship Mode] DESC