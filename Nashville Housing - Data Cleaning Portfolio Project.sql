 -- Data Cleaning

 SELECT *
 FROM NashvilleHousing

 SELECT SaleDateConverted, CONVERT(Date, SaleDate)
 FROM NashvilleHousing

 UPDATE NashvilleHousing
 SET SaleDate = CONVERT(Date, SaleDate)

 ALTER TABLE NashvilleHousing
 ADD SaleDateConverted Date;

 UPDATE NashvilleHousing
 SET SaleDateConverted = CONVERT(Date,SaleDate)

 ----------------------------------------------------------------


 SELECT *
 FROM NashvilleHousing
-- WHERE PropertyAddress is NULL
 ORDER BY ParcelID


 SELECT Table1.ParcelID, Table1.PropertyAddress, Table2.ParcelID, Table2.PropertyAddress, ISNULL(Table1.PropertyAddress, Table2.PropertyAddress)
 FROM NashvilleHousing Table1
 JOIN NashvilleHousing Table2
	ON Table1.ParcelID = Table2.ParcelID
	AND Table1.[UniqueID ] <> Table2.[UniqueID ]
WHERE Table1.PropertyAddress is NULL


UPDATE Table1
SET Table1.PropertyAddress = ISNULL(Table1.PropertyAddress, Table2.PropertyAddress)
FROM NashvilleHousing Table1
JOIN NashvilleHousing Table2
	ON Table1.ParcelID = Table2.ParcelID
	AND Table1.[UniqueID ] <> Table2.[UniqueID ]
WHERE Table1.PropertyAddress is NULL


--SELECT *
--FROM NashvilleHousing
--WHERE PropertyAddress is NULL


---------------------------------------------------


SELECT PropertyAddress, SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) - 1) AS SplitAddress,
SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) + 1, LEN(PropertyAddress)) AS SplitCity
FROM NashvilleHousing

ALTER TABLE NashvilleHousing
ADD PropertySplitAddress nvarchar(255);

UPDATE NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) - 1)


ALTER TABLE NashvilleHousing
ADD PropertySplitCity nvarchar(255);

UPDATE NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) + 1, LEN(PropertyAddress))


--SELECT *
--FROM NashvilleHousing


SELECT OwnerAddress,
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3) AS SplitAddress,
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2) AS SplitCity,
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1) AS SplitState
FROM NashvilleHousing

ALTER TABLE NashvilleHousing
ADD OwnerSplitAddress nvarchar(255);

UPDATE NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3);

ALTER TABLE NashvilleHousing
ADD OwnerSplitCity nvarchar(255);

UPDATE NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2);

ALTER TABLE NashvilleHousing
ADD OwnerSplitState nvarchar(255);

UPDATE NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1);

--SELECT *
--FROM NashvilleHousing;

---------------------------------------------------------------------------

SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2;

SELECT SoldAsVacant,
CASE
	WHEN SoldAsVacant = 'Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
END
FROM NashvilleHousing
--WHERE SoldAsVacant = 'Y' OR SoldAsVacant = 'N'

UPDATE NashvilleHousing
SET SoldAsVacant = CASE
	WHEN SoldAsVacant = 'Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
END



-----------------------------------------

WITH RowNumCTE AS (
SELECT *,
ROW_NUMBER() OVER (PARTITION BY 
					ParcelID,
					PropertyAddress,
					SaleDate,
					SalePrice,
					LegalReference
					ORDER BY
					UniqueID
) AS row_num
FROM NashvilleHousing
)
DELETE
FROM RowNumCTE
WHERE row_num > 1;



--------------------------------------

SELECT *
FROM NashvilleHousing;

ALTER TABLE NashvilleHousing
DROP COLUMN PropertyAddress, SaleDate, OwnerAddress, TaxDistrict