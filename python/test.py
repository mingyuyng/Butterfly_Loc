import numpy as np
import torch
import model as md
import scipy.io as sio


device = torch.device('cuda:0' if torch.cuda.is_available() else 'cpu')

WINDOW_LIGHT = 8
WINDOW_TEMP = 16
LIGHT_RESO = 60
TEMP_RESO = 1
LENGTH_LIGHT = WINDOW_LIGHT * LIGHT_RESO
LENGTH_TEMP = WINDOW_TEMP * TEMP_RESO

gap = 4
light_net = md.CNN_Light(LENGTH_LIGHT, 128, 5, 128, 0).to(device)
#temp_net = md.CNN_Temp(LENGTH_TEMP * 2, 0, 256).to(device)

light_net.load_state_dict(torch.load('model_light.w', map_location=torch.device('cpu')))
# temp_net.load_state_dict(torch.load('model/CNN_tmp_final_drop0_neu256_len16_2019.w'))

light_net.eval()
# temp_net.eval()


############################

NAME = 'Mexico_HOBO_Month_3_Day_11'
data = sio.loadmat('../Testdata/' + NAME + '.mat')
light_test = data['test_light']
#temp_test = data['test_temp']

results_light = np.zeros((light_test.shape[0], light_test.shape[1]))
#results_temp = np.zeros((light_test.shape[0], light_test.shape[1]))

for i in range(light_test.shape[0]):
    light = torch.from_numpy(light_test[i, :, :]).float().unsqueeze(1).to(device)
    #temp = torch.from_numpy(temp_test[i, :, :]).float().to(device)
    #temp = torch.cat((temp[:, gap:24 - gap], temp[:, gap + 24:-gap]), 1)

    light_result = light_net(light)
    #tmp_result = temp_net(temp)

    light_result = torch.sigmoid(light_result)
    #tmp_result = torch.sigmoid(tmp_result)

    results_light[i, :] = light_result.cpu().squeeze().detach().numpy()
    #results_temp[i, :] = tmp_result.cpu().squeeze().detach().numpy()


path_light = '../results/result_' + NAME + '.mat'
#path_temp = 'data_arb/results/' + 'result_temp_alt_F0.5_lay3_' + NAME
#path_hybrid = 'test_results/test_result_hybrid_' + str(WINDOW) + '/' + str(n + 1) + '.mat'
#path_large = 'test_results/test_result_large_' + str(WINDOW) + '/' + str(n + 1) + '.mat'

sio.savemat(path_light, {'results': results_light})
#sio.savemat(path_temp, {'results': results_temp})
#sio.savemat(path_large, {'results': results_large})
#sio.savemat(path_hybrid, {'results': results_hybrid})
#results = results / np.max(results)
#xx, yy = np.where(results > 0.9)
#zz = results[results > 0.9]

#print(np.sum(x[xx] * zz / sum(zz)))
#print(np.sum(y[yy] * zz / sum(zz)))
