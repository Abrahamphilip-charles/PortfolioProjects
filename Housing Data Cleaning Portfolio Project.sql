
--Cleaning Data in SQL Queries

select * from [dbo].[housingtable]


--standardize date format

select saledate,convert(date,saledate) from Portfolioproject.dbo.housingtable

update housingtable set saledate=convert (date,saledate)

alter table housingtable add saledateconverted date;

update housingtable set saledateconverted =convert (date,saledate)



--populate property address data


select * 
from Portfolioproject.dbo.housingtable
--where propertyaddress is null
order by parcelid



select  a.parcelid, a.propertyaddress , b.parcelid, b.propertyaddress, isnull(a.propertyaddress,b.propertyaddress)
from Portfolioproject.dbo.housingtable a
join Portfolioproject.dbo.housingtable b
on a.parcelid = b.parcelid
and a.[uniqueid]<>b.[uniqueid]
where a.propertyaddress is null


update a set propertyaddress=isnull(a.propertyaddress,b.propertyaddress)
from Portfolioproject.dbo.housingtable a
join Portfolioproject.dbo.housingtable b
on a.parcelid = b.parcelid
and a.[uniqueid]<>b.[uniqueid]
where a.propertyaddress is null


--Breaking out address into individual columns(address,city,state)

select propertyaddress
from Portfolioproject.dbo.housingtable
--where propertyaddress is null
--order by parcelid

SELECT
SUBSTRING(propertyaddress, 1, CHARINDEX(',', PropertyAddress)-1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address

From PortfolioProject.dbo.housingtable


ALTER TABLE housingtable
Add PropertySplitAddress Nvarchar(255);

Update housingtable
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE housingtable
Add PropertySplitCity Nvarchar(255);

Update housingtable
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))



Select *
From PortfolioProject.dbo.housingtable



Select OwnerAddress 
From PortfolioProject.dbo.housingtable 
order by owneraddress desc;


Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From PortfolioProject.dbo.housingtable



ALTER TABLE housingtable
Add OwnerSplitAddress Nvarchar(255);

Update housingtable
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE housingtable
Add OwnerSplitCity Nvarchar(255);

Update housingtable
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)



ALTER TABLE housingtable
Add OwnerSplitState Nvarchar(255);

Update housingtable
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)



Select *
From PortfolioProject.dbo.housingtable






-- Change Y and N to Yes and No in "Sold as Vacant" field



Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From PortfolioProject.dbo.housingtable
Group by SoldAsVacant
order by 2




Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From PortfolioProject.dbo.housingtable


Update housingtable
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END


--Remove duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From PortfolioProject.dbo.housingtable
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress



Select *
From PortfolioProject.dbo.housingtable



-- Delete Unused Columns



Select *
From PortfolioProject.dbo.housingtable

ALTER TABLE PortfolioProject.dbo.housingtable
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate