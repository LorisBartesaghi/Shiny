create_Y <- function(min_slid, max_slid, labelling, dataframe){
  #create a new vector needed for the plot
  new_vector <- vector(mode = "numeric", length = length(labelling))
  #find the correspondent number of column for the years in input
  min_slider <- grep(min_slid, colnames(dataframe))
  max_slider <- grep(max_slid, colnames(dataframe))
  
  #create the for loop for creating the vector
  for (w in 1:length(labelling)){
    for (z in min_slider: max_slider)
      new_vector[w] <- new_vector[w] + dataframe[w, z]
    
  }
  new_vector
}
