import random
import csv
import logging
import uuid
import polars as pl

from faker import Faker
from datetime import date, datetime, timedelta

# Configuracion logs
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s',
    datefmt='%Y-%m-%d %H:%M:%S',
    handlers=[logging.StreamHandler()]
)

# Funcion para creacion de datos
def create_data(locale: str) -> Faker:
    logging.info(f"Created synthetic data for {locale.split('_')[-1]} country code.")
    return Faker(locale)

# Funcion para generar un registro
def generate_record(fake: Faker) -> list:
    person_name      = fake.name()
    user_name        = person_name.replace(" ", "").lower()
    email            = f"{user_name}@{fake.free_email_domain()}"
    personal_number  = fake.ssn()
    birth_date       = fake.date_of_birth()
    address          = fake.address().replace("\n", ", ")
    Phone_number     = fake.phone_number()
    mac_address      = fake.mac_address()
    ip_address       = fake.ipv4()
    clave            = fake.iban()
    accessed_at      = fake.date_time_between("-1y")
    session_duration = random.randint(0, 36_000)
    download_speed   = random.randint(0, 1_000)
    upload_speed     = random.randint(0, 8_000)
    consumer_traffic = random.randint(0, 2_000_000)

    return [
        person_name,
        user_name,
        email,
        personal_number,
        birth_date,
        address,
        Phone_number,
        mac_address,
        ip_address,
        clave,
        accessed_at,
        session_duration,
        download_speed,
        upload_speed,
        consumer_traffic
    ]


def write_to_csv(file_path: str, rows: int) -> None:
    fake = create_data("es_MX")

    headers = [
        "person_name",
        "user_name",
        "email",
        "personal_number",
        "birth_date",
        "address",
        "Phone_number",
        "mac_address",
        "ip_address",
        "clave",
        "accessed_at",
        "session_duration",
        "download_speed",
        "upload_speed",
        "consumer_traffic"
    ]

    with open(file_path, mode="w", encoding="utf-8", newline="") as file:
        writer = csv.writer(file)
        writer.writerow(headers)
        for _ in range(rows):
            writer.writerow(generate_record(fake))

    logging.info(f"Written {rows} records to the csv file.")


def add_id(file_name: str) -> None:
    df = pl.read_csv(file_name)
    uuid_list = [str(uuid.uuid4()) for _ in range(df.height)]
    df = df.with_columns(pl.Series("unique_id", uuid_list))
    df.write_csv(file_name)
    logging.info("Added UUID to the dataset.")


def update_datetime(file_name: str, run: str) -> None:
    if run == 'next':
        current_time   = datetime.now().replace(microsecond=0)       # ✅ now()
        yesterday_time = str(current_time - timedelta(days=1))
        df = pl.read_csv(file_name)
        df = df.with_columns(pl.lit(yesterday_time).alias("accessed_at"))  # ✅ typo corregido
        df.write_csv(file_name)
        logging.info("Updated accessed timestamp")


if __name__ == "__main__":
    logging.info(f"Started batch processing for {date.today()}.")

    output_file = f"C:/Users/mtopete/Documents/BigData/batch_{date.today()}.csv"

    if str(date.today()) == "2026-05-19":
        records  = random.randint(100_372, 100_372)
        run_type = "first"
    else:
        records  = random.randint(0, 1_101)
        run_type = "next"

    write_to_csv(f"{output_file}", records)
    add_id(output_file)
    update_datetime(output_file, run_type)

    logging.info(f"Finished batch processing {date.today()}.")