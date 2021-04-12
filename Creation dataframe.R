create_df <- function(aggregation, array0, vec_names, vec_time){
 for (i in 1:nrow(aggregation)){
  for (j in 1:nrow(array0)){
    for (z in 1:ncol(array0)){
      if(aggregation[i,1] == vec_names[j] && aggregation[i,2]== vec_time[z]){
        array0[j,z] <- array0[j,z] + aggregation[i,3]
      }
    }
  }
 }
array0
}


