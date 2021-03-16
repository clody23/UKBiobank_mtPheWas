This folder includes two directories:


- `plotting` which includes all scripts used for plotting main figures and extended data figures

- `recalling` which includes all scripts used to perform manual mtSNVs variant recalling

and three scripts:

- `Multinomial_regression.R` used to perform multinomial regression between mitochondrial macro-haplogroups and pathogenic mtSNVs

- `get_UK_region.py` used to retrieve UK administrative regions (region, county and city) associated to UK Biobank postcode of home location at assessment (fields #20033, #20074, #20034, #20075) using the `reverse_geocoder` Python module (v. 1.5.1)

```
Usage:

python get_UK_region.py infile.txt outfile.txt
```


- `parse_ukbb_coord_by_city.py`
