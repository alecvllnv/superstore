import pandas as pd


# Load file
file_path = "sample_-_superstore.xls"

df = pd.read_excel(file_path)


# Examine data
print("Shape:")
print(df.shape)

print("\nColumns:")
print(df.columns.tolist())

print("\nFirst 5 rows:")
print(df.head())

print("\nData types:")
print(df.dtypes)

print("\nMissing values:")
print(df.isnull().sum())

print("\nDuplicate rows:")
print(df.duplicated().sum())

print("\nUnique values:")
print(df.nunique())

print("\nNumeric summary:")
print(df.describe())

print("\nCategorical summary:")
print(df.describe(include="object"))

print("\nOrder date range:")
print(df["Order Date"].min(), "to", df["Order Date"].max())

print("\nShip date range:")
print(df["Ship Date"].min(), "to", df["Ship Date"].max())


# Clean column names
df.columns = (
    df.columns
    .str.strip()
    .str.lower()
    .str.replace(" ", "_", regex=False)
    .str.replace("-", "_", regex=False)
    .str.replace("/", "_", regex=False)
)

print("\nCleaned columns:")
print(df.columns.tolist())


# Clean text
text_columns = df.select_dtypes(
    include=["object"]
).columns

for col in text_columns:
    df[col] = (
        df[col]
        .astype("string")
        .str.strip()
    )


# Convert dates
df["order_date"] = pd.to_datetime(
    df["order_date"],
    errors="coerce"
)

df["ship_date"] = pd.to_datetime(
    df["ship_date"],
    errors="coerce"
)


# Convert numbers
numeric_columns = [
    "row_id",
    "postal_code",
    "sales",
    "quantity",
    "discount",
    "profit"
]

for col in numeric_columns:
    df[col] = pd.to_numeric(
        df[col],
        errors="coerce"
    )


# Check duplicates
duplicate_count = df.duplicated().sum()

print("\nDuplicate rows:", duplicate_count)

if duplicate_count > 0:
    df = df.drop_duplicates()


# Check missing values
print("\nMissing values after cleaning:")
print(df.isnull().sum())


# Check invalid values
print("\nData quality checks:")

invalid_sales = (df["sales"] < 0).sum()
print("Negative sales:", invalid_sales)

invalid_quantity = (df["quantity"] <= 0).sum()
print("Invalid quantity:", invalid_quantity)

invalid_discount = (
    (df["discount"] < 0) |
    (df["discount"] > 1)
).sum()

print("Invalid discount:", invalid_discount)


# Check dates
invalid_dates = (
    df["ship_date"] < df["order_date"]
).sum()

print(
    "Ship date before order date:",
    invalid_dates
)


# Create date columns
df["order_year"] = df["order_date"].dt.year
df["order_month"] = df["order_date"].dt.month
df["order_month_name"] = df["order_date"].dt.month_name()
df["order_quarter"] = df["order_date"].dt.quarter


# Calculate shipping days
df["shipping_days"] = (
    df["ship_date"] - df["order_date"]
).dt.days


# Final check
print("\nFinal shape:")
print(df.shape)

print("\nFinal columns:")
print(df.columns.tolist())

print("\nFirst 5 cleaned rows:")
print(df.head())


# Save file
output_file = "superstore_cleaned.csv"

df.to_csv(
    output_file,
    index=False
)

print(
    "\nCleaned file saved as:",
    output_file
)
