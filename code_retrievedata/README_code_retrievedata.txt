README [last updated 6-May-2021]

This dataset is from the paper titled
    "Differential retention contributes to racial/ethnic disparity in
      U.S. academia"
    By: Allison K. Shaw, Chiara Accolla, Jeremy M. Chacón, Taryn L.
      Mueller, Maxime Vaugeois, Ya Yang, Nitin Sekar, Daniel E. Stanton

    Published in: TBD

Contact ashaw@umn.edu for assistance.

This "code_retrievedata" folder contains 7 matlab (.m files):

    runme_retrievedata.m: calls other .m functions to (1) retrieve model
      structure data and (2) retrieve race/ethnicity data, and saves the
      output as .csv data files

    do_structure_data_retrieval.m: load raw NSF data for model stages

    do_group_data_retrieval_UGD.m: retrieve NSF bachelors degrees group
      data

    do_group_data_retrieval_GR.m: retrieve NSF grad student group data

    do_group_data_retrieval_PD.m: retrieve NSF postdoc group data

    do_group_data_retrieval_faculty.m: retrieve NSF faculty group data

    do_group_data_retrieval_residency.m: retrieve NSF data on graduate
      student degrees by residency
      
