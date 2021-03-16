This folder includes the scripts used to plot main figures and extended data figures. Source files used by these scripts can be found in `UKBiobank_mtPheWas/source_files/`


- `EDFs`      

        |----`Geopandas_Map_v6.ipynb` jupyter notebook to generate EDF1.

- `Figure1`        

        |----`ggplot_scplot_Figure1b.R` used to generate Figure 1b. 
          Usage:    
		Rscript ggplot_scplot_Figure1b.R Figure1b_genotyped.txt Affx-92047866A Affx-92047866B Genotype  color.R A B Figure1b.png
		Rscript ggplot_scplot.R Figure1c.txt minor_allele_frequency_recalled minor_allele_frequency_raw fonts.R "Post-recalling MAF" "Genotyped MAF" Figure1d.png
		Rscript ggplot_scplot_Figure1dGenotyped.R Figure1d_genotyped.txt MAF_UKBB MAF_Ref colors_scplot_new.R "UKBiobank MAF" "Reference MAF" Figure1d_genotyped.png
		Rscript ggplot_scplot_Figure1dImputed.R Figure1d_imputed.txt MAF_UKBB MAF_Ref colors_scplot_new.R "UKBiobank MAF" "Reference MAF" Figure1d_imputed.png
	   
- `Figure2`    

        |----`Geopandas_Map_v5.ipynb` jupyter notebook to generate Figure2.

- `Figure3_and_4`    

        |----`plotfins_fig3.R` and `plotfins_fig4.R` used to generate Figure3 and 4. 
        Usage: 
                 Rscript plotfins_fig3.R
                 Rscript plotfins_fig4.R
        
