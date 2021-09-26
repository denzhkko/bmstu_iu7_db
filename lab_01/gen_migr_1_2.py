import csv
import psycopg2

from typing import *
from faker import Faker

from gen_table_data import RC_LISTENERS, CSV_DIRNAME


faker = Faker()


def gen_listeners_uuid() -> List[str]:
    conn = psycopg2.connect(user='deniska',password='deniska',
                            host='localhost',port=5432,dbname='musicdb')
    cursor = conn.cursor()
    cursor.execute('SELECT id FROM listeners');
    uuids = [v[0] for v in cursor.fetchall()]
    cursor.close()
    conn.close()

    return uuids

def gen_listeners_languages_countries(uuids):
    filename = CSV_DIRNAME + "/tmp_listeners_lc.csv"
    t_row_count = RC_LISTENERS

    with open(filename, 'w', newline='') as csvfile:
        writer = csv.writer(csvfile, delimiter=',')

        for uuid in uuids:
            writer.writerow([
                uuid,
                faker.language_name(),
                faker.country(),
                ])


def main():
    uuid_listeners = gen_listeners_uuid()
    gen_listeners_languages_countries(uuid_listeners)


main()
