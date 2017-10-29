import numpy as np
import matplotlib.pyplot as plt
import pandas as pd

xl = pd.rea("data.xlsx")


x = np.arange(0, 5, 0.1);
y = np.sin(x)
plt.plot(x, y)
plt.show()

	