# Network Energy Computation Function
# 
# This function calculates the normalized energy of a network based on its connectivity matrix.
# The energy is determined by summing up the product of connections for all unique triplets of nodes
# and then normalizing by the total number of triplets.
# 
# Usage:
#   connMatrix: A square numeric matrix representing the network connectivity.
#   Returns the average energy across triplet of nodes in the network.
#
# Author: Majid Saberi
# Date: March 31, 2024
#
# Example:
#   connMatrix <- matrix(runif(9), nrow = 3)
#   energy <- NetworkEnergy(connMatrix)
#   print(energy)
#
# If you use this code, please cite: 
# Majid Saberi et al. (2024). Navigating the brain's energy landscape during cognitive control: a network-based approach

# Function to calculate the normalized energy of a network
# based on the connectivity matrix 'x'.
NetworkEnergy <- function(connMatrix){
  # Ensure the input is a square matrix
  if (!is.matrix(connMatrix) || nrow(connMatrix) != ncol(connMatrix)) {
    stop("Input must be a square matrix")
  }
  
  # Initialize variables
  dimSize <- nrow(connMatrix)
  countTriplets <- 0
  totalEnergy <- 0
  
  # Iterate over all unique triplets of nodes
  for(i in 1:(dimSize-2)){
    for(j in (i+1):(dimSize-1)){
      for(k in (j+1):dimSize){
        # Calculate the energy for the current triplet
        tripletEnergy <- connMatrix[i,j] * connMatrix[i,k] * connMatrix[k,j]

        # Make the triplet energy value to the dimensionless form
        tripletEnergy <- sign(tripletEnergy) * abs(tripletEnergy)^(1/3)
        
        # Update the total energy and triplet count
        totalEnergy <- totalEnergy + tripletEnergy
        countTriplets <- countTriplets + 1
      }
    }
  }
  
  # Return the network energy (average energy over triplets)
  averageEnergy <- -1 * totalEnergy / countTriplets
  return(averageEnergy)
}
