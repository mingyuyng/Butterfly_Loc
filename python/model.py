import torch
import torch.nn as nn


class Flatten(nn.Module):
    def __init__(self):
        super(Flatten, self).__init__()

    def forward(self, x):
        N = x.shape[0]
        return x.view(N, -1)


class Sandwich(nn.Module):
    def __init__(self, c_in, c_out, filter_size):
        super(Sandwich, self).__init__()

        self.net = nn.Sequential(
            nn.Conv1d(c_in, c_out, filter_size, stride=1, padding=(filter_size - 1) // 2),
            nn.BatchNorm1d(c_out),
            nn.ReLU(),
            nn.MaxPool1d(kernel_size=2, stride=2)
        )

    def forward(self, x):
        return self.net(x)


class CNN_Light(nn.Module):
    def __init__(self, length, channel, num_layers, num_neu, pdrop):
        super(CNN_Light, self).__init__()

        self.len = length

        blocks = [Sandwich(1, channel, 7)]
        self.len = self.len // 2
        for _ in range(num_layers - 1):
            blocks.append(Sandwich(channel, channel, 3))
            self.len = self.len // 2

        blocks.append(Flatten())
        blocks.append(nn.Linear(self.len * channel, num_neu))
        blocks.append(nn.Dropout(p=pdrop))
        blocks.append(nn.Linear(num_neu, num_neu))
        blocks.append(nn.Linear(num_neu, 1))

        self.net = nn.Sequential(*blocks)

    def forward(self, x):
        return self.net(x)


class CNN_Temp(nn.Module):
    def __init__(self, size, pdrop, num_neu):
        super(CNN_Temp, self).__init__()

        self.relu = nn.ReLU()
        self.drop = nn.Dropout(p=pdrop)

        self.fc1 = nn.Linear(size, num_neu)
        self.fc2 = nn.Linear(num_neu, num_neu)
        self.fc3 = nn.Linear(num_neu, num_neu)
        self.fc4 = nn.Linear(num_neu, 1)

    def forward(self, x):

        x = self.fc1(x)            # Din = 16*256, Dout = 1024
        x = self.relu(x)
        x = self.drop(x)
        x = self.fc2(x)            # Din = 16*256, Dout = 1024
        x = self.relu(x)
        x = self.fc3(x)            # Din = 1024, Dout = 1024
        x = self.relu(x)
        x = self.fc4(x)
        return x
