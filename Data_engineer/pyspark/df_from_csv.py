fifa_df = spark.read.csv(file_path, header=True, inferSchema=True)

print("There are {} rows in the fifa_df DataFrame".format(fifa_df.count()))

fifa_df.createOrReplaceTempView('fifa_df_table')

query = '''SELECT Age FROM fifa_df_table WHERE Nationality == "Germany"'''

fifa_df_germany_age = spark.sql(query)

fifa_df_germany_age.describe().show()

fifa_df_germany_age_pandas = fifa_df_germany_age.toPandas()

fifa_df_germany_age_pandas.plot(kind='density')
plt.show()