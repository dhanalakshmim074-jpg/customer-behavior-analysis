from pydoc import describe
import pandas as pd
df=pd.read_csv(r"C:\Users\dhana\Downloads\customer_shopping_behavior.csv",sep='\t')

print(df.head())

print(df.tail())
print(df.columns)
print(df.shape)
print(df.describe(include="all"))
df.info()
print(df.isnull().sum())
print(df.columns)


df['Review Rating']=(df.groupby("Category")["Review Rating"].transform(lambda x:x.fillna(x.median())))

print(f"error:{df['Review Rating'].isnull().sum()}")

df.columns=df.columns.str.lower().str.replace(" ","_")
print(df.columns)

df.rename(columns={"purchase_amount_(usd)":"purchase_amount"},inplace=True)


df["age_group"]=pd.cut(df['age'],bins=[0,18,35,60,100],labels=["child","young","adult",'senior'])
print(df[["age","age_group"]].head(10))#for multiple column selecting

print(df["frequency_of_purchases"].unique())
df["frequency_of_purchases_days"]=df["frequency_of_purchases"].map({'Fortnightly':14,'Weekly':7,'Annually':365,
                                                                                                'Every 3 Months':90,'Monthly':30,'Bi-Weekly':14,'Quarterly':90})


print(df["frequency_of_purchases"].value_counts().reset_index())


(df['promo_code_used']==df['discount_applied']).all()


df.drop("promo_code_used",axis=1,inplace=True)
from sqlalchemy import create_engine
engine=create_engine("mysql+pymysql://root:Dhana123#@Localhost:3306/customer")
df.to_sql('customer',con=engine,index=False,if_exists='replace')