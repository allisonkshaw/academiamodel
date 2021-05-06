README [last updated 6-May-2021]

This dataset is from the paper titled
    "Differential retention contributes to racial/ethnic disparity in
      U.S. academia"
    By: Allison K. Shaw, Chiara Accolla, Jeremy M. Chacón, Taryn L.
      Mueller, Maxime Vaugeois, Ya Yang, Nitin Sekar, Daniel E. Stanton

    Published in: TBD

Contact ashaw@umn.edu for assistance.

This "code_runsimulations" folder contains 12 matlab (.m files):

    runme_runcode.m: calls all other functions in 4 steps: (1) loads and
      cleans model structure data, (2) estimates overall model transitions
      (independent of race/ethnicity), (3) loads and cleans race/ethncity
      data, and (4) runs simulations

    do_structure_data_clean.m: input raw NSF data for model stages, trim
      and interpolate, and output 

    do_transition_estimates.m: calculate estimates of the number of
      individuals transitioning among 
    
    do_group_data_clean.m: input raw NSF data for groups, trim and smooth,
      convert to fraction, and output

    do_simulations.m: simulate the number of individuals in each stage
      and each year for each group
	three sets this
	set a. main simulations (start in 1991, feed in U data)
	set b. vary input stage (start in 1991, feed in U or G or A data)
	set c. vary start year (start in 1991 or 2001 or 2010, feed in U
	  or G or A data)

    plot_fig2_figS7.m: plots figures 2 and S7, giant figures comparing
      data and model and census for all groups and stages [uses scenario a]
      
    plot_fig3.m: plots figure 3, number in each academic stage over time 

    plot_fig4.m: plots model-v-data metric figure [uses set b]

    plot_figS1S2.m: plots figures S1 and S2 data describing the pipeline
      (# degrees, people in each stage), both the raw data as well as the
      trimmed interpolated data that was used
     
    plot_figS3S4S5.m: plots group data (number of individuals by race
      ethnicity) in each stage, also plots breakdown of PhD degrees by
      temporary vs permanent residents

    plot_figS6.m: plots the estimates for transitions between stages

    plot_figS8.m: plots model-v-data metric over time figure [uses set c]

    plot_figS9.m: plots model figure with and without international
      students

Along with .jpg copies of the figure files.


xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx


make_results_table.m: output the data to use in the table of results (see supplement) [uses set a]

