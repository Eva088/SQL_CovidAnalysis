 #exporting the Covid Vaccines and Covid Deaths csv files to the MySQL database 'CovidAnalysis'

import pandas as pd; 

#Reading the csv files

deaths = pd.read_csv('CovidDeaths.csv')
vaccines = pd.read_csv('CovidVaccinations.csv')

#creating the dataframes

deaths = pd.DataFrame(deaths)
vaccines = pd.DataFrame(vaccines) 

#connecting to MySQL server

from sqlalchemy import create_engine


#connecting to the 'CovidAnalysis' database

host = 'localhost'
user = 'root'
password = '*************'
database = 'CovidAnalysis'

#creating an engine

engine = create_engine(f"mysql+pymysql://{user}:{password}@{host}/{database}")

#Exporting the dataframe to MySQL

# Export DataFrame to MySQL table
df.to_sql(name='CovidDeaths', con=engine, if_exists='replace', index=True)
df.to_sql(name='CovidVaccines', con=engine, if_exists='replace', index=True)

