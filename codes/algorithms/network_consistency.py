### Check consistency of network
### whether a student is a friend of the other student
### whether a student is a contact of the other student in a social media app WeChat
### whether a student is a roommate of the other student.
### In the normal cases, if student X knows student Y, then student Y should also know student X
### Based on this, we check "Consistency"

import pandas as pd 
import numpy as np 
import matplotlib.pyplot as plt

# BAD = [71, 77, 78, 82, 86, 104, 107, 125, 130, 132, 138]


class FriendshipNetwork(object):
    def __init__(self, file_path="./data/network_data/t3_friend_binary.csv"):
        self.data = pd.read_csv(file_path)

    def check_consistency(self, absolute=True):
        consistency_list = []
        for i in range(0, self.data.shape[0]):
            temp_row = list(self.data.iloc[i, :])
            temp_col = list(self.data.iloc[:, i])
            if absolute:
                difference = list(map(lambda x: abs(x[0] - x[1]), zip(temp_col, temp_row)))
            else:
                difference = list(map(lambda x: x[0] - x[1], zip(temp_col, temp_row)))
            consistency_list.append(sum(difference))

        return consistency_list

    def save_cons_df(self, file_name):
        cons_list = self.check_consistency(absolute=False)
        abs_cons_list = self.check_consistency(absolute=True)
        cons_df = pd.DataFrame([cons_list, abs_cons_list]).T
        cons_df = cons_df.rename({0:"col_row", 1:"abs"}, axis="columns")
        
        cons_df.to_csv("./results/"+file_name)
        print("data saved. ")

    def select_abnormal_index(self, threshold=20, absolute=True):
        cons_df = pd.DataFrame(self.check_consistency(absolute=absolute))
        abnormal_data = cons_df.loc[cons_df[0] >= threshold]

        return abnormal_data
    
    def count_number(self, row=True):
        if row:
            total_num = self.data.apply(lambda x: x.sum(), axis=1)
        else:
            total_num = self.data.apply(lambda x: x.sum())
        
        return total_num

    def select_abnormal_count_num_index(self, threshold=7):
        cons_df = pd.DataFrame(self.count_number())
        abnormal_data = cons_df.loc[cons_df[0] >= threshold]

        return abnormal_data


def draw_hist(data):
    figure, ax = plt.subplots(1, 1)
    ax.hist(data, bins=np.arange(0, 41, 1))

    plt.show()


if __name__ == "__main__":
    fn = FriendshipNetwork("./data/network_data/t3_roommate.csv")
    draw_hist(fn.count_number())
