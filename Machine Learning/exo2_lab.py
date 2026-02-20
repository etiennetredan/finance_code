import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.metrics import confusion_matrix
from keras.models import Sequential
from keras.layers import Dense
import numpy as np

from prep_Data import myData

from sklearn.preprocessing import MinMaxScaler
from sklearn.preprocessing import StandardScaler

# Encoding the class

def encodeClass(s_class, nbClasses):
    if (nbClasses==3):
        if (s_class==-1):
            return [1,0,0]
        if (s_class==0):
            return [0,1,0]
        else:
            return[0,0,1]
    else:
        if (s_class==-1):
            return [1,0]
        else:
            return[0,1]

# Defining data
nbColumns = len(myData.columns)
classes = myData['CLS'].unique().tolist()
nbClasses = len(classes)
nbexamples = myData.shape
print(nbexamples)

X = myData.values[:,:nbColumns-1]
Y = myData.values[:,nbColumns-1]

encoded_Y = np.array([encodeClass(y, nbClasses) for y in list(Y)])

X_train, X_test, Y_train, Y_test = train_test_split( X, encoded_Y, test_size = 0.7, random_state = 100)

nn = Sequential()
nn.add(Dense(5, input_dim=nbColumns-1, activation='sigmoid'))
nn.add(Dense(nbClasses, activation='softmax'))
nn.summary()

nn.compile(loss='binary_crossentropy', optimizer='adam', metrics=['accuracy'])
nn.fit(X_train, Y_train, epochs=300, batch_size=10)

score = nn.evaluate(X_test, Y_test, verbose=2)
print('Test accuracy:', score[1])

#For more information, we build the confusion matrix
Y_pred = nn.predict(X_test)
Y_pred_1 = Y_pred.argmax(axis=1)
Y_test_1 = Y_test.argmax(axis=1)
confusion = confusion_matrix(Y_pred_1, Y_test_1)
print(confusion)


columns = myData.columns.tolist()
print(columns)
for numcol in range(len(columns)):
    print(columns[numcol].mean())
    
x = myData['MA'].mean()
print(x)
# Summary statistics (mean, max, min) for selected columns
cols_summary = ['MA', 'SD', 'SO', 'RSI', 'CLS']
summary_df = myData[cols_summary].agg(['mean', 'max', 'min']).T.reset_index()
summary_df.columns = ['feature', 'mean', 'max', 'min']
print('\nSummary dataframe:')
print(summary_df)



scaler1 = MinMaxScaler()
scaler1.fit(X)
X_scaled1 = scaler1.transform(X)
for numc in range(nbColumns-1):
    C = X_scaled1[:,numc]
    print(min(C),max(C))

scaler2 = StandardScaler()
scaler2.fit(X)
X_scaled2 = scaler2.transform(X)
for numc in range(nbColumns-1):
    C = X_scaled2[:,numc]
    print(round(np.mean(C),2),round(np.std(C),2))


X_train, X_test, Y_train, Y_test = train_test_split( X, encoded_Y, test_size = 0.7, random_state = 100)

nn = Sequential()
nn.add(Dense(5, input_dim=nbColumns-1, activation='sigmoid'))
nn.add(Dense(nbClasses, activation='softmax'))
nn.summary()

nn.compile(loss='binary_crossentropy', optimizer='adam', metrics=['accuracy'])
nn.fit(X_train, Y_train, epochs=300, batch_size=10)

score = nn.evaluate(X_test, Y_test, verbose=2)
print('Test accuracy:', score[1])