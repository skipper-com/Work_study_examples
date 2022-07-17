Feature Selection 
=================
Original dataset features described in 'feature_info.txt'

Based on original datasets two new datasets were assemled:
1. merged train and test datasets with two new columns ('df_full'):
- subject : numeric variable of subject of measurement
- activity_labels : factor variable describes type of activity of measurement

2. Summary dataset ('df_summary') with the same as 'df_full' columns but grouped by activity and subject with meaned variables in each group
