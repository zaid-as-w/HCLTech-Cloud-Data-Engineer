import os
import sys

# Ensure UTF-8 output encoding for console
if hasattr(sys.stdout, 'reconfigure'):
    sys.stdout.reconfigure(encoding='utf-8')

# Configure environment variables to prevent Windows path/quoting and Python version mismatch issues
os.environ["JAVA_HOME"] = r"C:\Program Files\Java\jdk-21.0.12"
os.environ["PYSPARK_PYTHON"] = sys.executable
os.environ["PYSPARK_DRIVER_PYTHON"] = sys.executable

from pyspark.sql import SparkSession
from pyspark.sql.functions import col, avg, count, round

def main():
    # Initialize SparkSession
    spark = SparkSession.builder \
        .appName("PySpark_Employee_Analysis") \
        .master("local[*]") \
        .config("spark.driver.host", "localhost") \
        .getOrCreate()

    # Set log level to ERROR to suppress verbose INFO/WARN logs
    spark.sparkContext.setLogLevel("ERROR")

    # Sample employee dataset with 15 records
    data = [
        (101, "Amit Sharma",    "IT",          75000, "2021-03-15"),
        (102, "Priya Nair",     "HR",          55000, "2020-07-10"),
        (103, "Rahul Verma",    "Finance",     82000, "2019-11-01"),
        (104, "Sneha Patel",    "IT",          68000, "2022-01-20"),
        (105, "Vikram Singh",   "Marketing",   58000, "2021-08-14"),
        (106, "Neha Gupta",     "HR",          62000, "2018-05-22"),
        (107, "Arjun Rao",      "Finance",     95000, "2017-09-30"),
        (108, "Ananya Roy",     "IT",          91000, "2019-04-18"),
        (109, "Rohan Das",      "Marketing",   64000, "2022-11-05"),
        (110, "Kavita Sen",     "Finance",     71000, "2020-02-12"),
        (111, "Deepak Joshi",   "IT",          59000, "2023-06-01"),
        (112, "Pooja Reddy",    "HR",          48000, "2023-03-15"),
        (113, "Suresh Kumar",   "Marketing",   78000, "2018-12-10"),
        (114, "Manoj Tiwari",   "Finance",     63000, "2021-10-25"),
        (115, "Isha Malhotra",  "IT",          87000, "2020-08-19")
    ]

    columns = ["EmployeeID", "EmployeeName", "Department", "Salary", "JoiningDate"]

    # Create DataFrame
    df = spark.createDataFrame(data, columns)

    print("=" * 80)
    print("SECTION C: PYSPARK DATA ENGINEERING - QUESTION 7")
    print("=" * 80)

    # -------------------------------------------------------------
    # (a) Display the schema and first five records (1 mark)
    # -------------------------------------------------------------
    print("\n" + "=" * 65)
    print("(a) SCHEMA AND FIRST FIVE RECORDS")
    print("=" * 65)
    print("\n[DataFrame Schema]:")
    df.printSchema()

    print("\n[First 5 Records]:")
    df.show(5, truncate=False)

    # -------------------------------------------------------------
    # (b) Filter employees whose monthly salary > Rs. 60,000 (1 mark)
    # -------------------------------------------------------------
    print("\n" + "=" * 65)
    print("(b) EMPLOYEES WITH MONTHLY SALARY > Rs. 60,000")
    print("=" * 65)
    df_filtered = df.filter(col("Salary") > 60000)
    df_filtered.show(truncate=False)

    # -------------------------------------------------------------
    # (c) Add an AnnualSalary column calculated from monthly salary (1 mark)
    # -------------------------------------------------------------
    print("\n" + "=" * 65)
    print("(c) DATAFRAME WITH 'AnnualSalary' COLUMN (Salary * 12)")
    print("=" * 65)
    df_with_annual = df.withColumn("AnnualSalary", col("Salary") * 12)
    df_with_annual.show(15, truncate=False)

    # -------------------------------------------------------------
    # (d) Group employees by department: average salary and employee count (2 marks)
    # -------------------------------------------------------------
    print("\n" + "=" * 65)
    print("(d) DEPARTMENT-WISE SUMMARY (AVG SALARY & EMPLOYEE COUNT)")
    print("=" * 65)
    dept_summary = df.groupBy("Department").agg(
        round(avg("Salary"), 2).alias("AverageSalary"),
        count("EmployeeID").alias("EmployeeCount")
    ).orderBy("Department")
    dept_summary.show(truncate=False)

    # -------------------------------------------------------------
    # (e) Display the five highest-paid employees (1 mark)
    # -------------------------------------------------------------
    print("\n" + "=" * 65)
    print("(e) FIVE HIGHEST-PAID EMPLOYEES")
    print("=" * 65)
    top_five_paid = df.orderBy(col("Salary").desc()).limit(5)
    top_five_paid.show(truncate=False)

    # Stop SparkSession
    spark.stop()

if __name__ == "__main__":
    main()
