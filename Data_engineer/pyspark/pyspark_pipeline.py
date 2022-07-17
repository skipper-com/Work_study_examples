
annotations_df = spark.read.csv('annotations.csv.gz', sep='|')
full_count = annotations_df.count()

comment_count = annotations_df.where(col('_c0').startswith('#')).count()
no_comments_df = spark.read.csv('annotations.csv.gz', sep='|', comment='#')
no_comments_count = no_comments_df.count()
print("Full count: %d\nComment count: %d\nRemaining count: %d" % (full_count, comment_count, no_comments_count))


tmp_fields = F.split(annotations_df['_c0'],'\t')
annotations_df = annotations_df.withColumn('colcount', F.size(tmp_fields))
annotations_df_filtered = annotations_df.filter(~ (annotations_df.colcount < 5))
final_count = annotations_df_filtered.count()
print("Initial count: %d\nFinal count: %d" % (initial_count, final_count))


split_cols = F.split(annotations_df['_c0'], '\t')
split_df = annotations_df.withColumn('folder', split_cols.getItem(0))
split_df = split_df.withColumn('filename', split_cols.getItem(1))
split_df = split_df.withColumn('width', split_cols.getItem(2))
split_df = split_df.withColumn('height', split_cols.getItem(3))
split_df = split_df.withColumn('split_cols', split_cols)


def retriever(cols, colcount):
  return cols[4:colcount]

udfRetriever = F.udf(retriever, ArrayType(StringType()))
split_df = split_df.withColumn('dog_list', udfRetriever(split_df.split_cols, split_df.colcount))
split_df = split_df.drop('_c0').drop('colcount').drop('split_cols')


valid_folders_df = valid_folders_df.withColumnRenamed('_c0', 'folder')
split_count = split_df.count()
joined_df = split_df.join(F.broadcast(valid_folders_df), "folder")
joined_count = joined_df.count()
print("Before: %d\nAfter: %d" % (split_count, joined_count))


split_count = split_df.count()
joined_count = joined_df.count()
invalid_df = split_df.join(F.broadcast(joined_df), 'folder', 'outer')
invalid_count = invalid_df.count()
print(" split_df:\t%d\n joined_df:\t%d\n invalid_df: \t%d" % (split_count, joined_count, invalid_count))

invalid_folder_count = invalid_df.select('folder').distinct().count()
print("%d distinct invalid folders found" % invalid_folder_count)


print(joined_df.select(joined_df.dog_list).show(10, truncate=False))
DogType = StructType([
	StructField("breed", StringType(), False),
    StructField("start_x", IntegerType(), False),
    StructField("start_y", IntegerType(), False),
    StructField("end_x", IntegerType(), False),
    StructField("end_y ", IntegerType(), False),
])


def dogParse(doglist):
  dogs = []
  for dog in doglist:
    (breed, start_x, start_y, end_x, end_y) = dog.split(',')
    dogs.append((breed, int(start_x), int(start_y), int(end_x), int(end_y)))
  return dogs

udfDogParse = F.udf(dogParse, ArrayType(DogType))
joined_df = joined_df.withColumn('dogs', udfDogParse('dog_list')).drop('dog_list')
joined_df.select(F.size('dogs')).show(10)

def dogPixelCount(doglist):
  totalpixels = 0
  for dog in doglist:
    totalpixels += (dog[3] - dog[1]) * (dog[4] - dog[2])
  return totalpixels

udfDogPixelCount = F.udf(dogPixelCount, IntegerType())
joined_df = joined_df.withColumn('dog_pixels', udfDogPixelCount('dogs'))

joined_df = joined_df.withColumn('dog_percent', (joined_df.dog_pixels / (joined_df.width * joined_df.height)) * 100)
joined_df.where('dog_percent > 60').show(10)