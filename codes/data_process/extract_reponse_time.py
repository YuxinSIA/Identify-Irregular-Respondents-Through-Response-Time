import pandas as pd 
import numpy as np 


class TSDataTransformer(object):
    '''
        Input log_all data, output response time data with NAs
    '''
    def __init__(self, file_path="./data/processed_data/log_aug_processed_q1.csv"):
        self.data = pd.read_csv(file_path)
        self.data = self.data.sort_values(by=["mid", "test", "oid", "qid"])
        self.data.index = range(0, self.data.shape[0])
        self.id_list = list(self.data["mid"].drop_duplicates())

    def get_timestamp(self):
        ts_df = pd.DataFrame([])
        for i in self.id_list:
            temp_df = self.data.loc[self.data["mid"] == i]
            temp_df.index = range(0, temp_df.shape[0])
            ts_df = pd.concat([ts_df, temp_df["time_stamp"]], axis=1)
            ts_df = ts_df.rename({"time_stamp":"mid_"+str(i)}, axis="columns")

        self.ts_df = ts_df
        return self.ts_df

    def get_response_time(self):
        self.get_timestamp()
        rt_df = self.ts_df.diff()
        rt_df = rt_df.iloc[1:, :]
        rt_df = rt_df.T
        #rt_df = rt_df.fillna(rt_df.mean())
        self.rt_df = rt_df
        return rt_df

    def save_response_time(self, file_name):
        self.get_response_time()
        self.rt_df.to_csv("./data/time_data/"+file_name)
        print(file_name + " saved.")



def save_all_response_time():
    aug_time = TSDataTransformer(file_path="./data/processed_data/log_aug_processed_q1.csv")
    sept_time = TSDataTransformer(file_path="./data/processed_data/log_sept_processed_q1.csv")
    oct_time = TSDataTransformer(file_path="./data/processed_data/log_oct_processed_q1.csv")

    aug_time.save_response_time("time_aug_q1.csv")
    sept_time.save_response_time("time_sept_q1.csv")
    oct_time.save_response_time("time_oct_q1.csv")


if __name__ == "__main__":
    save_all_response_time()

