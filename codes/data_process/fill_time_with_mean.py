import pandas as pd 
import numpy as np 
import matplotlib.pyplot as plt


class MeanFiller(object):
    '''
        Input original response time data, output processed response time. 
    '''
    def __init__(self, file_path=".data/time_data/time_aug_q1.csv"):
        self.data = pd.read_csv(file_path, index_col=0)
        self.data = self.data.dropna(how="all")

    def fill_na(self):
        self.data = self.data.fillna(self.data.mean())

    def replace_neg(self):
        for j in range(0, self.data.shape[1]):
            temp_mean = self.data.iloc[:, j].mean()
            for i in range(0, self.data.shape[0]):
                if self.data.iloc[i, j] < 0:
                    self.data.iloc[i, j] = temp_mean

    def replace_outlier(self):
        temp_mean = self.data.mean()
        for i in range(0, self.data.shape[0]):
            Q1 = np.percentile(self.data.iloc[i, :], 25)
            Q3 = np.percentile(self.data.iloc[i, :], 75)
            IQR = Q3 - Q1
            for j in range(0, self.data.shape[1]):
                if self.data.iloc[i, j] > Q3 + 1.5 * IQR or self.data.iloc[i, j] < Q1 - 1.5 * IQR:
                    self.data.iloc[i, j] = temp_mean[j]

    def count_outlier(self):
        count = [0] * self.data.shape[0]
        for i in range(0, self.data.shape[0]):
            Q1 = np.percentile(self.data.iloc[i, :], 25)
            Q3 = np.percentile(self.data.iloc[i, :], 75)
            IQR = Q3 - Q1
            for j in range(0, self.data.shape[1]):
                if self.data.iloc[i, j] > Q3 + 1.5 * IQR or self.data.iloc[i, j] < Q1 - 1.5 * IQR:
                    count[i] += 1

        return pd.DataFrame(count, index=self.data.index)

    def count_outlier_col(self):
        count = [0] * self.data.shape[0]
        for j in range(0, self.data.shape[1]):
            Q1 = np.percentile(self.data.iloc[:, j], 25)
            Q3 = np.percentile(self.data.iloc[:, j], 75)
            IQR = Q3 - Q1
            for i in range(0, self.data.shape[0]):
                if self.data.iloc[i, j] > Q3 + 1.5 * IQR or self.data.iloc[i, j] < Q1 - 1.5 * IQR:
                    count[i] += 1

        return pd.DataFrame(count, index=self.data.index)


    def save_data(self, file_name):
        self.data.to_csv("./data/time_data/"+file_name)
        print(file_name + " saved")


def fill_all_with_mean(file_path=["./data/time_data/time_aug_q1.csv", 
                        "./data/time_data/time_sept_q1.csv", 
                        "./data/time_data/time_oct_q1.csv"], 
                        output_name=["time_aug_q1_filled.csv", 
                        "time_sept_q1_filled.csv", 
                        "time_oct_q1_filled.csv"]):
    for i in range(0, 3):
        rt = MeanFiller(file_path=file_path[i])
        rt.fill_na()
        rt.replace_neg()
        rt.replace_outlier()
        rt.save_data(file_name=output_name[i])
        


if __name__ == "__main__":
    fill_all_with_mean()

