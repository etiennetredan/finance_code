import pandas as pn
import datetime

#Reading the data : 6 explanatory variables + the one that will be used to 
#define the response variable
data_GDP = pn.read_csv("GDP_US.csv", sep=";", header=1)
data_HDebt = pn.read_csv("HouseholdDebt_US.csv", sep=";", header=1)
data_NFDebt = pn.read_csv("NonFinancialDebt_US.csv", sep=";", header=1)
data_PDebt = pn.read_csv("PublicDebt_US.csv", sep=";", header=1)
data_TBills = pn.read_csv("3MtreasuryBills_US.csv", sep=";", header=1)
data_Y10Years = pn.read_csv("Yield10years_US.csv", sep=";", header=1)
data_IShPrices = pn.read_csv("IndexTotalSharePrices_US.csv", sep=";", header=1)

#Transforming the variables that should be transformed
#1. Computing GDP Growth

GDP_Growth = []
ind = 0
while (ind+1<len(data_GDP)):
  val = (data_GDP['Value'][ind+1]-data_GDP['Value'][ind])/data_GDP['Value'][ind]
  GDP_Growth.append(100*val)
  ind = ind+1
  
data_size = min(len(GDP_Growth), len(data_HDebt), len(data_NFDebt), len(data_PDebt), len(data_TBills), len(data_Y10Years), len(data_IShPrices))

#2. Creating the tables HDebt, NFDebt and PDebt
HDebt = []
NFDebt = []
PDebt = []
ind = 0
while(ind<data_size):
  HDebt.append(data_HDebt['Value'][ind])
  NFDebt.append(data_NFDebt['Value'][ind])
  PDebt.append(data_PDebt['Value'][ind])
  ind = ind+1

#3. 3M Traesury bills : monthly values ---> quaterly values
TBills = []
ind = 0
while (ind+3<len(data_TBills)):
  val = (data_TBills['Value'][ind]+data_TBills['Value'][ind+1]+data_TBills['Value'][ind+2])/3
  TBills.append(val)
  ind = ind+3
  
#4. Yield 10 years  : Creating monthly values ---> quaterly values using geometric mean
Y10Years = []
ind = 0
while (ind+3<len(data_Y10Years)):
  val = (data_Y10Years['Value'][ind]+data_Y10Years['Value'][ind+1]+data_Y10Years['Value'][ind+2])/3
  Y10Years.append(val)
  ind = ind+3
  
#5. We compute the quarterly percentage change in the index of total share prices.
IShPrices = []
ind = 0
while (ind+3<len(data_IShPrices)):
  val = (data_IShPrices['Value'][ind+3]-data_IShPrices['Value'][ind])/data_IShPrices['Value'][ind]
  IShPrices.append(100*val)
  ind = ind+3
  
#6. We create a first dataframe containing the whole data


dates = data_GDP['Quarter'][1:]
Quarter = [datetime.datetime.strptime(d, "%Y-%m-%d") for d in dates]

myData = pn.DataFrame({'Quarter':Quarter[0:data_size], 'GDP_Growth':GDP_Growth[0:data_size], 'HDebt':HDebt,\
                       'NFDebt':NFDebt, 'PDebt':PDebt,\
                       'TBills':TBills[0:data_size], 'Y10Years':Y10Years[0:data_size],  'IShPrices':IShPrices[0:data_size]})

#7. We create a second dataframe in which to each value of GDP growth we associate two values of
# each explanatory variable :  4 quarters ahead and the quarter before, 
#e.g. to GDP Growth of 2006Q2 --> 2005Q1 and 2005Q2.
myData2 = pn.DataFrame({'GDP_Growth':GDP_Growth[5:data_size], 'HDebt_4Q':HDebt[1:data_size-4],\
                       'NFDebt_4Q':NFDebt[1:data_size-4], 'PDebt_4Q':PDebt[1:data_size-4],\
                       'TBills_4Q':TBills[1:data_size-4], 'Y10Years_4Q':Y10Years[1:data_size-4],  'IShPrices_4Q':IShPrices[1:data_size-4],\
                       'HDebt_5Q':HDebt[0:data_size-5],\
                       'NFDebt_5Q':NFDebt[0:data_size-5], 'PDebt_5Q':PDebt[0:data_size-5],\
                       'TBills_5Q':TBills[0:data_size-5], 'Y10Years_5Q':Y10Years[0:data_size-5],  'IShPrices_5Q':IShPrices[0:data_size-5]})


