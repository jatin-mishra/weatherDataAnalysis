
// loading data
weather = load 'structuredData/weatherData' using TextLoader() as (data:chararray);


// take date max Temp and MinTmp
dateAndTmp = foreach weather GENERATE TRIM(SUBSTRING(data,6,14)) as itIsdate, TRIM(SUBSTRING(data,38,45)) as MaxTmp, TRIM(SUBSTRING(data,46,53)) as MinTmp;

// get hotdays > 25
hotDays = FILTER dateAndTmp by (float)MaxTmp > 25;
store hotDays into 'hotdays' using PigStorage('\t');

// get Cold Days
coldDays = FILTER dateAndTmp by (float)MinTmp < -25;
store coldDays into 'coldDays' using PigStorage('\t');

// get coldestDay
coldrenew = load 'structuredData/coldDays' using PigStorage('\t') as (itIsDate:chararray, tmpMax:float, tmpMin:float);
groupedColdest = Group coldrenew All;
MinTmp = foreach groupedColdest GENERATE MIN(coldrenew.tmpMin) as minimum;
coldestData = FILTER coldrenew by tmpMin == MinTmp.minimum;
coldestData = foreach coldestData GENERATE itIsData;


