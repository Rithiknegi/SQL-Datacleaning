/* Cleasing The Data  By Rithik Negi*/
---Let's go

Select * From PortfolioProject.dbo.[Nashville Housing Data for Data Cleaning(CSV)]


-- Standardize Date Format


Select saleDateConverted,CONVERT(Date,SaleDate) From PortfolioProject.dbo.[Nashville Housing Data for Data Cleaning(CSV)]

Update [Nashville Housing Data for Data Cleaning(CSV)]
SET SaleDate=CONVERT(Date, SaleDate)

Alter Table [Nashville Housing Data for Data Cleaning(CSV)]
Add SaleDateConverted Date;

Update [Nashville Housing Data for Data Cleaning(CSV)]
SET SaleDateConverted = CONVERT(Date,SaleDate)


---------------------------------------------------------------------------
--Populate Property Address data

Select* From PortfolioProject.dbo.[Nashville Housing Data for Data Cleaning(CSV)]
--WHERE PropertyAddress is null
order by ParcelID



Select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress,ISNULL(a.PropertyAddress,b.PropertyAddress) From PortfolioProject.dbo.[Nashville Housing Data for Data Cleaning(CSV)] a
JOIN PortfolioProject.dbo.[Nashville Housing Data for Data Cleaning(CSV)] b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID]<>b.[UniqueID]
Where a.PropertyAddress is null

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject.dbo.[Nashville Housing Data for Data Cleaning(CSV)] a
JOIN PortfolioProject.dbo.[Nashville Housing Data for Data Cleaning(CSV)] b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID]<>b.[UniqueID]
Where a.PropertyAddress is null

-- Breaking out Address into Individual Columns (Address,City,State)



Select PropertyAddress From PortfolioProject.dbo.[Nashville Housing Data for Data Cleaning(CSV)]
--WHERE PropertyAddress is null
--order by ParcelID


Select 
SUBSTRING(PropertyAddress, 1,CharINDEX(',', PropertyAddress)-1) as Address
,SUBSTRING(PropertyAddress, CharINDEX(',', PropertyAddress)+1,LEN(PropertyAddress)) as Address

FROM PortfolioProject.dbo.[Nashville Housing Data for Data Cleaning(CSV)]

Alter Table [Nashville Housing Data for Data Cleaning(CSV)]
Add PropertySplitAddress Nvarchar(255);

Update [Nashville Housing Data for Data Cleaning(CSV)]
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1,CharINDEX(',', PropertyAddress)-1)

Alter Table [Nashville Housing Data for Data Cleaning(CSV)]
Add PropertySplitCity Nvarchar(255);

Update [Nashville Housing Data for Data Cleaning(CSV)]
SET PropertySplitCity = SUBSTRING(PropertyAddress, CharINDEX(',', PropertyAddress)+1,LEN(PropertyAddress))

select* FROM PortfolioProject.dbo.[Nashville Housing Data for Data Cleaning(CSV)]





--------------------------------------------------------------------------------------------------



select OwnerAddress FROM PortfolioProject.dbo.[Nashville Housing Data for Data Cleaning(CSV)]

SELECT 
PARSENAME(REPLACE(OwnerAddress,',','.'),3),
PARSENAME(REPLACE(OwnerAddress,',','.'),2),
PARSENAME(REPLACE(OwnerAddress,',','.'),1)
From PortfolioProject.dbo.[Nashville Housing Data for Data Cleaning(CSV)]


Alter Table [Nashville Housing Data for Data Cleaning(CSV)]
Add OwnerSplitAddress Nvarchar(255);

Update [Nashville Housing Data for Data Cleaning(CSV)]
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3)

Alter Table [Nashville Housing Data for Data Cleaning(CSV)]
Add OwnerSplitCity Nvarchar(255);

Update [Nashville Housing Data for Data Cleaning(CSV)]
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2)

Alter Table [Nashville Housing Data for Data Cleaning(CSV)]
Add OwnerSplitState Nvarchar(255);

Update [Nashville Housing Data for Data Cleaning(CSV)]
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'),1)

select* FROM PortfolioProject.dbo.[Nashville Housing Data for Data Cleaning(CSV)]



------------------------------------------------------------------------------------------

--- Change Y and N to Yes and No in 'Sold as Vacant' field

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From PortfolioProject.dbo.[Nashville Housing Data for Data Cleaning(CSV)]
Group by SoldAsVacant
order by 2




Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From PortfolioProject.dbo.[Nashville Housing Data for Data Cleaning(CSV)]


Update [Nashville Housing Data for Data Cleaning(CSV)]
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END



----------------------------------------------------------------------


----Remove Duplicate


WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER(
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 Order by
					UniqueID
					) row_num


From PortfolioProject.dbo.[Nashville Housing Data for Data Cleaning(CSV)]
--order by ParcelID

)

Select *
From RowNumCTE
where row_num>1
ORDER By PropertyAddress







-------------------------------------------------------------------------------------------------------------------

-- Delete Unused Columns



Select *
From PortfolioProject.dbo.[Nashville Housing Data for Data Cleaning(CSV)]


ALTER TABLE PortfolioProject.dbo.[Nashville Housing Data for Data Cleaning(CSV)]
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate









