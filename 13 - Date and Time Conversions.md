# Date and Time Conversions

## GETDATE [Link](https://www.mssqltips.com/sqlservertip/1145/date-and-time-conversions-using-sql-server/)

The date used for all of these examples is "2006-12-30 00:38:54.840".



---
### DATE ONLY FORMATS
Format  | Query | Sample
| ------------- |:-------------:| -----:|
1 | select convert(varchar, getdate(), 1) | 12/30/06
2 | select convert(varchar, getdate(), 2) | 06.12.30
3 | select convert(varchar, getdate(), 3) | 30/12/06
4 | select convert(varchar, getdate(), 4) | 30.12.06
5 | select convert(varchar, getdate(), 5) | 30-12-06
6 | select convert(varchar, getdate(), 6) | 30 Dec 06
7 | select convert(varchar, getdate(), 7) | Dec 30, 06
10 | select convert(varchar, getdate(), 10) | 12-30-06
11 | select convert(varchar, getdate(), 11) | 06/12/30
12 | select convert(varchar, getdate(), 12) | 061230
23 | select convert(varchar, getdate(), 23) | 2006-12-30
101 | select convert(varchar, getdate(), 101) | 12/30/2006
102 | select convert(varchar, getdate(), 102) | 2006.12.30
103 | select convert(varchar, getdate(), 103) | 30/12/2006
104 | select convert(varchar, getdate(), 104) | 30.12.2006
105 | select convert(varchar, getdate(), 105) | 30-12-2006
106 | select convert(varchar, getdate(), 106) | 30 Dec 2006
107 | select convert(varchar, getdate(), 107) | Dec 30, 2006
110 | select convert(varchar, getdate(), 110) | 12-30-2006
111 | select convert(varchar, getdate(), 111) | 2006/12/30
112 | select convert(varchar, getdate(), 112) | 20061230



---
### TIME ONLY FORMATS
Format  | Query | Sample
| ------------- |:-------------:| -----:|
8 | select convert(varchar, getdate(), 8) | 00:38:54
14 | select convert(varchar, getdate(), 14) | 00:38:54:840
24 | select convert(varchar, getdate(), 24) | 00:38:54
108 | select convert(varchar, getdate(), 108) | 00:38:54
114 | select convert(varchar, getdate(), 114) | 00:38:54:840



---
### DATE & TIME FORMATS
Format  | Query | Sample
| ------------- |:-------------:| -----:|
0 | select convert(varchar, getdate(), 0) | Dec 12 2006 12:38AM
9 | select convert(varchar, getdate(), 9) | Dec 30 2006 12:38:54:840AM
13 | select convert(varchar, getdate(), 13) | 30 Dec 2006 00:38:54:840AM
20 | select convert(varchar, getdate(), 20) | 2006-12-30 00:38:54
21 | select convert(varchar, getdate(), 21) | 2006-12-30 00:38:54.840
22 | select convert(varchar, getdate(), 22) | 12/30/06 12:38:54 AM
25 | select convert(varchar, getdate(), 25) | 2006-12-30 00:38:54.840
100 | select convert(varchar, getdate(), 100) | Dec 30 2006 12:38AM
109 | select convert(varchar, getdate(), 109) | Dec 30 2006 12:38:54:840AM
113 | select convert(varchar, getdate(), 113) | 30 Dec 2006 00:38:54:840
120 | select convert(varchar, getdate(), 120) | 2006-12-30 00:38:54
121 | select convert(varchar, getdate(), 121) | 2006-12-30 00:38:54.840
126 | select convert(varchar, getdate(), 126) | 2006-12-30T00:38:54.840
127 | select convert(varchar, getdate(), 127) | 2006-12-30T00:38:54.840


## DATEPART [Link](https://docs.microsoft.com/en-us/sql/t-sql/functions/datepart-transact-sql?view=sql-server-2017)


datepart | Abbreviations | Return value
| ------------- |:-------------:| -----:|
year | yy, yyyy | 2007
quarter | qq, q | 4
month | mm, m | 10
dayofyear | dy, y | 303
day | dd, d | 30
week | wk, ww | 45
weekday | dw | 1
hour | hh | 12
minute | mi, n | 15
second | ss, s | 32
millisecond | ms | 123
microsecond | mcs | 123456
nanosecond | ns | 123456700
TZoffset | tz | 310

### DATEPART
#### functions returns an integer value
[Link](https://www.mssqltips.com/sqlservertip/2507/determine-sql-server-date-and-time-parts-with-datepart-and-datename-functions/)
DATEPART ( @Date value used is '2019-09-25 19:47:00.8631597' )

Unit of time | DatePart Arguments | Query | Result
| ------------- |:-------------:| -----:| -----:|
ISO_WEEK | isowk, isoww, ISO_WEEK | SELECT DATEPART(ISO_WEEK,@Date) | 39
TZoffset | tz, TZoffset | SELECT DATEPART(TZoffset,@Date) | 0
NANOSECOND | ns, nanosecond | SELECT DATEPART(nanosecond,@Date) | 863159700
MICROSECOND | mcs, microsecond | SELECT DATEPART(microsecond,@Date) | 863159
MILLISECOND | ms, millisecond | SELECT DATEPART(millisecond,@Date) | 863
SECOND | ss, s, second | SELECT DATEPART(ss,@Date) | 0
MINUTE | mi, n, minute | SELECT DATEPART(minute,@Date) | 47
HOUR | hh, hour | SELECT DATEPART(HOUR,@Date) | 19
WEEKDAY | dw, weekday | SELECT DATEPART(weekday,@Date) | 4
WEEK | wk, ww, week | SELECT DATEPART(wk,@Date) | 39
DAY | dd, d, day | SELECT DATEPART(d,@Date) | 25
DAYOFYEAR | dy, y, dayofyear | SELECT DATEPART(dayofyear,@Date) | 268
MONTH | mm, m. month | SELECT DATEPART(m,@Date) | 9
QUARTER | qq, q, quarter | SELECT DATEPART(quarter,@Date) | 3
YEAR | yy, yyyy, year | SELECT DATEPART(YYYY,@Date) | 2019


### DATENAME
#### function returns a string value - with the DATENAME function, the only units of time that return values different than the DATEPART function are the WEEKDAY and MONTH.

Unit of time | DateName Arguments | Query | Result
| ------------- |:-------------:| -----:| -----:|
ISO_WEEK | isowk, isoww, ISO_WEEK | SELECT DATENAME(ISO_WEEK,@Date) | 39
TZoffset | tz, TZoffset | SELECT DATENAME(TZoffset,@Date) | +00:00
NANOSECOND | ns, nanosecond | SELECT DATENAME(nanosecond,@Date) | 863159700
MICROSECOND | mcs, microsecond | SELECT DATENAME(microsecond,@Date) | 863159
MILLISECOND | ms, millisecond | SELECT DATENAME(millisecond,@Date) | 863
SECOND | ss, s, second | SELECT DATENAME(ss,@Date) | 0
MINUTE | mi, n, minute | SELECT DATENAME(minute,@Date) | 47
HOUR | hh, hour | SELECT DATENAME(HOUR,@Date) | 19
WEEKDAY | dw, weekday | SELECT DATENAME(weekday,@Date) | Wednesday
WEEK | wk, ww, week | SELECT DATENAME(wk,@Date) | 39
DAY | dd, d, day | SELECT DATENAME(d,@Date) | 25
DAYOFYEAR | dy, y, dayofyear | SELECT DATENAME(dayofyear,@Date) | 268
MONTH | mm, m. month | SELECT DATENAME(m,@Date) | September
QUARTER | qq, q, quarter | SELECT DATENAME(quarter,@Date) | 3
YEAR | yy, yyyy, year | SELECT DATENAME(YYYY,@Date) | 2019




