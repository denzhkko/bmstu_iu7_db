import csv

from faker import Faker

from gen_table_data import RC_LISTENERS, CSV_DIRNAME


faker = Faker()


def gen_listeners_languages_countries():
    filename = CSV_DIRNAME + "/tmp_listeners_lc.csv"
    t_row_count = RC_LISTENERS

    with open(filename, 'w', newline='') as csvfile:
        writer = csv.writer(csvfile, delimiter=',')

        for i in range(t_row_count):
            writer.writerow([
                i + 1,
                faker.language_name(),
                faker.country(),
                ])


def main():
    gen_listeners_languages_countries()


main()
