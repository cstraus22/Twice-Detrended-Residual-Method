# Twice-Detrended-Residual-Method

Due to the availability of sensors, many municipalities now have large amounts of temporally dense data for sewer flow. For management of combined sewer systems, there is a need to accurately decompose the total sewer flow into its constituent components: dry-weather flow (DWF) and rain-derived inflow and infiltration (RDII). Although current approaches have been successful in decoupling DWF and RDII for dry climates, they often miscalculate the flow components for wet and semi-wet climates or seasons. The twice-detrended residual method (TDRM), seeks to alleviate this drawback. Currently there is a gap within the literature on research dedicated to isolating and modeling dry weather flow from combined flow without requiring periods of climatic dry weather. This is code is for the TDRM, an efficient data-driven method that uses the combined flow data to decouple DWF and RDII components, therefore eliminating the need to remove wet-weather flow data. In addition, to reduce the effect of static DWF patterns on the residual RDII, the proposed method treats each day of the week as having a unique diurnal pattern. A Fast Fourier Transform (FFT) is used to evaluate model efficacy by comparing the amplitude of 12-hr and 24-hr signals in the raw flow data and the resulting RDII. 


Code for applying the Twice Detrended Residual Method to pattern recognition in non-stationary data, particularly applied to combined sewer system flow data.

Steps to run code:

1.) Either download the code and datasets or clone the repository.

2.) Open file named ParentCode.m

  -all other codes are run from this. The other codes can be modified and then run from this code.
  
  -Run each line of the code, it should ask you to select which dataset you would like analyze. The datasets used in the original study are provided in Example_datasets. The code is written to run with 5-minute interval data. This can be adjusted in the Agreggating.m file, where the intervals needed to average to hourly can be adjusted. The rest of the code is written to run with hourly data, changing this would involve making adjustments to all the files.

  -The code is all replicated in the smoothing folder so the steps are the same.
  
3.) Run each block of code to step through the functions. 
