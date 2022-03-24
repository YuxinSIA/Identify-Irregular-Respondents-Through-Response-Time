import pandas as pd 
import numpy as np 
from DTW_clustering import TSCluster


def cluster_ts_data(file_path="./data/time_data/time_aug_q1_filled.csv", name="mean", num_clust=2, num_iter=5, win_size=30):
    data = pd.read_csv(file_path, index_col=0)
    dtw = TSCluster(num_clust=num_clust)
    dtw.k_means_clust(data=np.array(data), num_iter=num_iter, w=win_size, progress=True)
    assign_dict = dtw.get_assignments()
    index_list = list(data.index)
    for i in range(0, len(index_list)):
        index_list[i] = int(index_list[i][4:])
    clust_result = pd.DataFrame(np.ones(data.shape[0]), index=index_list)
    for i in range(0, num_clust):
        for item in assign_dict[i]:
            clust_result.iloc[item, 0] = i

    clust_result.to_csv("./results/cluster/cluster_"+name+"_"+str(num_clust)+"_"+str(num_iter)+"_"+str(win_size)+".csv")
    print("data saved.")



if __name__ == "__main__":
    cluster_ts_data(file_path="./results/selected_q1_data_filled.csv", name="sq1_filled", 
                    num_clust=4, num_iter=50, win_size=50)

