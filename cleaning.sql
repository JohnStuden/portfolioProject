/*data cleaning in SQL Queries*/

select SaleDate, convert(Date,saledate)
from dbo.NashvilleHousing

--standerd date format

select saledateConverted,convert(Date,saledate)
from portfolioProject.dbo.NashvilleHousing

update NashvilleHousing
set SaleDate = convert(date, Saledate)

alter table nashvillehousing
add SaleDateConverted Date;

Update NashvilleHousing
set SaleDateConverted = convert(date, SaleDate)

--property address data

select *
from portfolioProject.dbo.NashvilleHousing
--where PropertyAddress is null
order by ParcelId

select a.parcelid, a.propertyAddress, b.parcelid, b.propertyAddress, isnull(a.propertyaddress,b.propertyaddress)
from portfolioProject.dbo.NashvilleHousing a
join portfolioProject.dbo.NashvilleHousing b
on a.parcelid=b.parcelid--parcle id is the same...
and a.[uniqueid] <> b.[uniqueid]--but not the same row.


update a
set propertyaddress = isnull(a.propertyaddress,b.propertyaddress)
from portfolioProject.dbo.NashvilleHousing a
join portfolioProject.dbo.NashvilleHousing b
on a.parcelid=b.parcelid--parcle id is the same...
and a.[uniqueid] <> b.[uniqueid]--but not the same row.
where a.propertyaddress is null

--breaking out address into intravidual columns (address, city, state)

select propertyaddress
from portfolioProject.dbo.nashvillehousing
--where propertyaddress is null
--order by parcelid

select
SUBSTRING(propertyaddress, 1, charindex(',',propertyaddress) -1 ) as address--stops at the comma the -1 gets rid of the comma
,SUBSTRING(propertyaddress, charindex(',',propertyaddress) +1 ,len(propertyaddress)) as address

from portfolioProject.dbo.nashvillehousing

ALTER TABLE NashvilleHousing
add propertysplitaddress nvarchar(255);

Update dbo.NashvilleHousing
set propertysplitaddress = SUBSTRING(propertyaddress, 1, charindex(',',propertyaddress) -1 )

alter table nashvillehousing
add propertysplitcity nvarchar(255);

Update NashvilleHousing
set propertysplitcity = SUBSTRING(propertyaddress, charindex(',',propertyaddress) +1 ,len(propertyaddress))


select *
from portfolioProject.dbo.nashvillehousing




--owner 

select Owneraddress
from portfolioProject.dbo.nashvillehousing

select 
parsename(replace(owneraddress,',','.'), 3),
parsename(replace(owneraddress,',','.'), 2),
parsename(replace(owneraddress,',','.'), 1)
from portfolioProject.dbo.NashvilleHousing


ALTER TABLE NashvilleHousing
add ownersplitaddress nvarchar(255);

Update dbo.NashvilleHousing
set ownersplitaddress = parsename(replace(owneraddress,',','.'), 3)

alter table nashvillehousing
add ownersplitcity nvarchar(255);

Update NashvilleHousing
set ownersplitcity = parsename(replace(owneraddress,',','.'), 2)

alter table nashvillehousing
add ownersplitst nvarchar(255);

Update NashvilleHousing
set ownersplitst = parsename(replace(owneraddress,',','.'), 1)

--change Y and N to yes and no "sold as vacent"

select Distinct(SoldAsVacant),count(SoldAsVacant)-- this query is giving ist a t-chart of y,n, yes, and no and a count of them
From portfolioProject.dbo.NashvilleHousing
group by SoldAsVacant
order by 2

select SoldAsVacant
,	CASE When SoldAsVacant ='Y' THEN 'Yes'
		 When SoldAsVacant ='N' THEN 'No'
		 ELSE SoldAsVacant 
		 END
From PortfolioProject.dbo.nashvillehousing

update NashvilleHousing
set SoldAsVacant= CASE When SoldAsVacant ='Y' THEN 'Yes'
		 When SoldAsVacant ='N' THEN 'No'
		 ELSE SoldAsVacant 
		 END
From PortfolioProject.dbo.nashvillehousing






--reomve duplicates

With ROWNUMCTE as(
select * ,
	row_number() over(
	PARTITION BY ParcelID,
				 PropertyAddress,
				 saleprice,
				 saledate,
				 legalReference
				 ORDER BY
					Uniqueid
					) row_num

from portfolioProject.dbo.NashvilleHousing
--ORDER BY ParcelID
)
select *--DELETE
from RowNumCTE
where row_NUM>1
--order by propertyaddress



select *
from portfolioProject.dbo.NashvilleHousing



--delete unused columns

select *
from portfolioProject.dbo.NashvilleHousing

alter table portfolioProject.dbo.NashvilleHousing
drop column owneraddress, taxdistrict, propertyaddress


alter table portfolioProject.dbo.NashvilleHousing
drop column saledate