# Whole-brain and Subnetwork Specific Network Energy Computation Script
#
# This script includes a function to calculate the normalized energy of a network 
# based on its connectivity matrix and a routine to apply this function to both 
# whole-brain and subnetwork connectivity matrices for multiple subjects and tasks.
# The energy is determined by summing up the product of connections for all unique 
# triplets of nodes and then normalizing by the total number of triplets.
# 
# Usage:
#   1. Ensure the 'NetworkEnergy' function is defined in your environment or sourced from an external file.
#   2. Adjust file paths and names as necessary to match your data structure.
#   3. Use the provided loop template to calculate energy for multiple subjects and networks.
#   4. The script outputs average energy values across triplets of nodes in the network.
#
# Author: Majid Saberi
# Date: March 31, 2024
#
# Example:
#   connMatrix <- matrix(runif(9), nrow = 3)
#   energy_whole_brain <- NetworkEnergy(connMatrix)
#   print(energy_whole_brain)
#   # Additional loop for processing multiple subjects and subnetworks is provided at the end of the script.
#
# If you use this code, please cite: 
# Majid Saberi et al. (2024). "Navigating the brain's energy landscape during cognitive control: 

# Ensure the 'NetworkEnergy' function is in your R working directory or adjust the path as needed.
source("NetworkEnergy.R")

# It is good practice not to set the working directory within scripts. Instead, instruct users to set their own working directory or use relative paths.
# setwd("path/to/your/data")

# Read the connectivity matrix file for the whole brain analysis.
# Replace 'power_229_sub-001_gng_inhibition.txt' with the actual file name you want to process.
# The file should be in a tab-separated format without headers.
atlas <- "Power229_10"
subjid <- "sub-001"
task <- "gng_inhibition"
connfile <- paste0(atlas, "_", subjid, "_", task, ".txt")
connmat <- read.csv(connfile, sep = "\t", header = FALSE)
connmat <- as.matrix(connmat)

# Calculate the energy of the whole brain network.
energy_whole_brain <- NetworkEnergy(connmat)

# For subnetwork analysis, ensure the labels file is in your R working directory or provide a path.
# Load node labels and coordinates. Users must adjust the file name as needed.
labels <- read.csv("Power_229node_10network_coordinates.csv")

# Specify the subnetwork of interest.
subnet <- "SomMot"

# Extract regions of interest (ROIs) for the specified subnetwork.
rois <- which(labels$Network == subnet)
subnetconn <- connmat[rois, rois]

# Calculate the energy of the subnetwork.
energy_subnet <- NetworkEnergy(subnetconn)

# At this point, you can print the energy values or write them to a file.
# print(energy_whole_brain)
# print(energy_subnet)

# Additional instructions for users:
# To use this script for multiple subjects and subnetworks, you will need to:
# 1. Localize your connectivity matrices for each subject and task.
# 2. Write a loop that imports these matrices for each subject.
# 3. Within the loop, call the NetworkEnergy function for whole brain and each subnetwork of interest.
# 4. Save the energy calculations to a data frame or write to files for later analysis.

# Example template for looping over multiple subjects and subnetworks:
# subjects <- c("sub-001", "sub-002", "sub-003") # Replace with actual subject IDs
# tasks <- c("task1", "task2") # Replace with actual task names
# subnets <- c("SomMot", "Visual", "DorsAttn") # Replace with actual network names
# 
# for(subj in subjects){
#   for(task in tasks){
#     connfile <- paste0(atlas, "_", subj, "_", task, ".txt")
#     connmat <- read.csv(connfile, sep = "\t", header = FALSE)
#     connmat <- as.matrix(connmat)
#     energy_whole_brain <- NetworkEnergy(connmat)
#     print(paste("Energy for", subj, task, "Whole Brain:", energy_whole_brain))
#     
#     for(net in subnets){
#       rois <- which(labels$Network == net)
#       subnetconn <- connmat[rois, rois]
#       energy_subnet <- NetworkEnergy(subnetconn)
#       print(paste("Energy for", subj, task, "Subnetwork", net, ":", energy_subnet))
#     }
#   }
# }
# 
# Note: This is a simplified example. In a real case scenario, you would also want to handle errors,
# such as missing files or incorrect file formats. Additionally, you would likely save the results
# to a data structure or write them to an output file rather than just printing them.
