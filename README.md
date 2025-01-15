# **Cell Linking Challenge - RWTH Submission (SamCeTra) - 30. Nov. 2024**
- Autor: Zhu Chen 
- Email: zhu.chen@lfb.rwth-aachen.de


## **Overview**  
- This repository contains a generalized cell-linking algorithm for linking pre-generated masks based on **SegmentAnything2 (SAM2)** [1]. The algorithm supports both 2D and 3D datasets. It can link masks that belong to the same cell across time frames, generate new masks for cells missing in intermediate time frames and detect cell mitosis. 
- For 2D datasets, the algorithm operates as a zero-shot method, leveraging a pretrained SAM2 model without requiring any additional training or fine-tuning.
- For 3D datasets, the algorithm offers two modes:
  - Linking-only Mode: Suitable for datasets with a nearly complete set of generated masks. This mode is training-free and computationally efficient.
  - Mask-generation Mode: Designed for datasets with numerous missing masks. This mode utilizes a fine-tuned **SAM-Med3D** [2] model (few-shot learning) to generate missing 3D masks for intermediate time frames.
---

## **Usage Instructions**

### **Prerequisites**
- System: Linux
- Conda  
- Python 3.10

### **Steps to Run**  
1. Identify the bash script for each dataset, named in the format `DatasetName-SequenceID.sh`.  
3. Run the bash script using the following command:  
   ```bash
   bash -i DatasetName-SequenceID.sh
   ```

### **Contents of the Bash Files**  
- **Environment Setup:**  
  - The script checks if required Conda environment already exists. 
  - If not, it creates a new environment and installs the packages listed in `requirements.txt`.
  - The installed environment is activated  

- **Algorithm Execution:**  
  - Once the environment is activated, the script calls `samcetra.sh` to execute the algorithm.  
  - Depending on the dataset type, one of the following Python scripts is executed:  
    - `linking_2d_general.py` (for 2D datasets)  
    - `linking_3d_general_linking_only.py` (for 3D datasets, linking only mode, no pretrained model required)
    - `linking_3d_general_gen_mask.py` (for 3D datasets, mask generation mode, pretrained model required)


---

## **Input Parameters**
The following parameters are required and should be set within the bash script:  

| Parameter         | Description                                                                                  | Notes                                                |
|--------------------|----------------------------------------------------------------------------------------------|------------------------------------------------------|
| `input_sequence`      | Path to the raw images                                                                       | Mandatory                                            |
| `mask_sequence`       | Path to the erroneous masks                                                                  | Mandatory                                            |
| `ouput_sequence`        | Path to store the results                                                                    | Mandatory                                            |
| `2d_or_3d`       | Specify whether the dataset is `2d` or `3d`                                                  | Mandatory                                            |
| `window_size`            | Local window size (varies by dataset)                                                        | Mandatory                                            |
| `dis_threshold`   | Size threshold for disappearing cells (varies by dataset)                                    | Mandatory                                            |
| `neighbor_dist`   | Distance threshold for linking neighboring cells (varies by dataset)                         | Only required for 2D datasets and linking-only mode of 3D datasets                           |
| `model`           | Fine-tuned 3D mask generation model      | Only required for mask-generation mode of 3D datasets, fine-tuned models are located in `trained_models`                    |

---

## **Output**
The algorithm generates the following outputs in the specified `ouput_sequence` folder:  
1. TIFF files named `mask{i}.tif`, where `i` represents the time frame index.  
2. A tracking information file, `res_track.txt`.  

---

## **Algorithm Summary**

### **1. Backward Tracking**
- The process starts with the masks from the last time frame.  
- For each mask in the current time frame:  
  - A local patch is cropped around the mask and compared with the corresponding patch in the previous time frame.  
  - Using point and bounding box prompts derived from the current frame’s mask, SAM2 predicts the mask position in the previous frame.  

### **2. Mask Linking**
- If a corresponding mask is found, it is linked to the current frame.  
- If no mask is identified:  
  - A new mask is generated using SAM2 (for 3D datasets, it is genreated by the fine-tuned SAM-Med3D model in mask-generation mode).  

### **3. Additional Functionalities**
The algorithm includes additional functionalities for:  
- Detecting new cells.  
- Detecting mitosis events.  
- Automatically correcting inaccurate linkages.
- Detailed description of the algorithm will be available later.  

### **4. Note**
In the submitted version, the results for all 3D datasets were generated using the mask-generation mode and the default settings of the bash scripts are configured for mask-generation mode.

---

## **Training Details (3D Datasets)**
- Missing intermediate 3D masks are generated using a fine-tuned **SAM-Med3D** model.  
- The model is fine-tuned individually for each 3D dataset, using ~10% of the dataset’s time frames for training. 
- Training script and detailed description of training will be available later. 

---

## **Citations**
- [1] Zhu, J., Qi, Y., & Wu, J. (2024). Medical SAM 2: Segment medical images as video via Segment Anything Model 2. arXiv preprint arXiv:2408.00874.
- [2] Wang, H., Guo, S., Ye, J., Deng, Z., Cheng, J., Li, T., Chen, J., Su, Y., Huang, Z., Shen, Y., Fu, B., Zhang, S., He, J., & Qiao, Y. (2023). SAM-Med3D. arXiv preprint arXiv:2310.15161.
