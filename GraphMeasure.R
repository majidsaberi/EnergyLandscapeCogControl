# Global Graph Measure Calculations Script
#
# This script is designed to calculate various global graph measures for brain connectivity
# networks. It includes functionality to work with both whole-brain connectivity matrices and
# specific subnetworks, allowing for a comprehensive analysis of the brain's network dynamics.
# The script utilizes the 'igraph' library and a developed function to compute measures
# such as the weighted clustering coefficient, average path length, modularity, and network energy.
#
# Usage:
# - The script expects connectivity matrices as input, in tab-separated values (TSV) format.
# - Users should specify the atlas, subject ID, and task to construct the filename for loading the
#   connectivity matrix.
# - The script also requires a CSV file containing labels for nodes, used to identify subnetworks.
#
# Calculated Measures:
# - Weighted Clustering Coefficient (GCC)
# - Average Path Length (GE)
# - Modularity (MOD)
# - Network Energy (NE)
#
# Requirements:
# - igraph: For network analysis and measure calculations.
# - A separate R script 'NetworkEnergy.R' containing the function to calculate network energy.
#
# Author: Majid Saberi
# Date: March 31, 2024
#
# If you use this code, please cite:
# Majid Saberi et al. (2024). "Navigating the brain's energy landscape during cognitive control: 
# A network-based approach." 
#
# Example:
# - Ensure 'NetworkEnergy.R', connectivity matrices, and node label files are in the working directory.
# - Adapt the 'atlas', 'subjid', 'task', and file paths as necessary.
# - Run the script to calculate the global graph measures for your data.
#
# Note: This script is a template for calculating global graph measures. Users may need to adjust
# file paths, network parameters, and subnetwork selections based on their specific datasets and
# research questions. Ensure all dependencies are installed and up to date.

# Load required libraries. Make sure to install them using install.packages() if not already installed.
library(igraph)          # For network analysis

# Source the NetworkEnergy function from the same directory. Adjust the path as needed.
source("NetworkEnergy.R")

# Example for loading and analyzing a connectivity matrix from a task
# Modify 'atlas', 'subjid', and 'task' variables as needed for your dataset.

atlas <- "Power229_10"
subjid <- "sub-001"
task <- "gng_inhibition"
# Construct file path. Adjust directory as needed.
connfile <- paste0(atlas, "_", subjid, "_", task, ".txt")
# Load the connectivity matrix. Ensure the file format matches.
connmat <- read.csv(connfile, sep = "\t", header = FALSE)

# Convert to matrix if not already
connmat <- as.matrix(connmat)

# Load labels for subnetworks. Adjust file name as needed.
labels <- read.csv("Power_229node_10network_coordinates.csv")

# Specify the subnetwork of interest and select ROIs
subnet <- "SomMot"
rois <- which(labels$Network == subnet)

# Subset the connectivity matrix for the specified subnetwork
connmat_subnet <- connmat[rois, rois]

# Use the following code to analyze connectivity at either the whole-brain or subnetwork level
# Set diagonal to zero to remove self-loops
diag(connmat_subnet) <- 0

# Create a graph object from the adjacency matrix
gr <- graph_from_adjacency_matrix(connmat_subnet, mode = "undirected", weighted = TRUE)

# Initialize a variable for graph measures
grm <- list()

# Compute the global clustering coefficient (GCC)
grm$GCC <- transitivity(gr, type = "weighted")

# Compute the average path length (GE)
grm$GE <- mean_distance(gr, weighted = TRUE)

# Detect communities using the walktrap method
wtc <- cluster_walktrap(gr, weights = E(gr)$weight)

# Compute the modularity of the detected community structure
grm$MOD <- modularity(wtc)

# Calculate the network energy
grm$NE <- NetworkEnergy(connmat_subnet)

# Print the graph measures
print(grm)

# Notes for users:
# - Ensure the connectivity matrix file follows the format: atlas_subjid_task.txt and is tab-separated.
# - Modify 'atlas', 'subjid', 'task', and 'labels' file path according to your data organization.
# - The script is set up for analysis of both whole-brain and subnetwork connectivity. Adjust as per your study needs.

# Further Adaptations for Users:
# This script is designed for a single subject and a specific task/subnetwork. However, you might
# be interested in analyzing a collection of subjects across different tasks or conditions and
# across various canonical networks. Below are suggestions on how to extend this script to handle
# such scenarios.

# Looping Over Multiple Subjects and Tasks:
# If you have connectivity matrices for multiple subjects and tasks, consider implementing a loop
# that iterates over subjects and tasks. Within each iteration, you can load the corresponding
# connectivity matrix and perform the analysis as shown above. Here is a conceptual outline:

# for (subj in list_of_subjects) {
#   for (task in list_of_tasks) {
#     # Construct file path for the current subject and task
#     connfile <- paste0(atlas, "_", subj, "_", task, ".txt")
#     # Load the connectivity matrix
#     connmat <- read.csv(connfile, sep = "\t", header = FALSE)
#     connmat <- as.matrix(connmat)
#     # Perform whole-brain analysis
#     # Set diagonal to zero, create graph object, and calculate measures
#
#     # Perform subnetwork analysis
#       for (subnet in list_of_subnetworks) {
#         rois <- which(labels$Network == subnet)
#         connmat_subnet <- connmat[rois, rois]
#         # Set diagonal to zero, create graph object, and calculate measures
#       }
#   }
# }

# Remember to initialize and store the results in a structured format (e.g., a list or data frame)
# so you can easily access and analyze the results after the loops complete.

# This approach allows for a comprehensive analysis across subjects, tasks, and networks, providing
# a holistic view of the brain's network dynamics. Be mindful of the computational load and consider
# optimizing or parallelizing your code for efficiency if processing a large dataset.
