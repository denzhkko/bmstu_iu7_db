import csv
import random
import pathlib

from faker import Faker
from faker_music import MusicProvider


CSV_DIRNAME = 'datasheets'
T_ROW_COUNT_DEF = 1000

RC_LABELS = T_ROW_COUNT_DEF
RC_BANDS = T_ROW_COUNT_DEF
RC_SONGS = T_ROW_COUNT_DEF
RC_ALBUMS = T_ROW_COUNT_DEF
RC_LISTENERS = T_ROW_COUNT_DEF

uuid_labels = []
uuid_bands = []
uuid_songs = []
uuid_albums = []
uuid_listeners = []

RC_REL_BCL = T_ROW_COUNT_DEF
RC_REL_BSS = T_ROW_COUNT_DEF
RC_REL_ACS = T_ROW_COUNT_DEF
RC_REL_LRS = T_ROW_COUNT_DEF

genders = ['male', 'female']

faker = Faker()
faker.add_provider(MusicProvider)


def create_csv_dir():
    p = pathlib.Path(".")
    csvp = p / CSV_DIRNAME

    if not csvp.exists():
        csvp.mkdir()


def gen_labels():
    filename = CSV_DIRNAME + "/labels.csv"
    t_row_count = RC_LABELS

    with open(filename, 'w', newline='') as csvfile:
        writer = csv.writer(csvfile, delimiter=',')

        for i in range(t_row_count):
            id = faker.unique.uuid4()
            writer.writerow([
                id,
                faker.company(),
                faker.name(),
                faker.year(),
                faker.country(),
                faker.text()
                ])
            uuid_labels.append(id)


def gen_bands():
    filename = CSV_DIRNAME + "/bands.csv"
    t_row_count = RC_BANDS

    with open(filename, 'w', newline='') as csvfile:
        writer = csv.writer(csvfile, delimiter=',')

        for i in range(t_row_count):
            id = faker.unique.uuid4()
            writer.writerow([
                id,
                # no way to gen band name.
                # coming soon by faker_music provider
                faker.sentence(random.randint(1, 3)),
                faker.year(),
                faker.country(),
                faker.text()
                ])
            uuid_bands.append(id)


def gen_songs():
    filename = CSV_DIRNAME + "/songs.csv"
    t_row_count = RC_SONGS

    with open(filename, 'w', newline='') as csvfile:
        writer = csv.writer(csvfile, delimiter=',')

        for i in range(t_row_count):
            id = faker.unique.uuid4()
            writer.writerow([
                id,
                # no way to gen song name
                faker.sentence(random.randint(1, 3)),
                faker.music_genre(),
                faker.language_name(),
                faker.text()
                ])
            uuid_songs.append(id)


def gen_albums():
    filename = CSV_DIRNAME + "/albums.csv"
    t_row_count = RC_ALBUMS

    with open(filename, 'w', newline='') as csvfile:
        writer = csv.writer(csvfile, delimiter=',')

        for i in range(t_row_count):
            id = faker.unique.uuid4()
            writer.writerow([
                id,
                # no way to gen album name
                faker.sentence(random.randint(1, 3)),
                faker.year(),
                faker.text()
                ])
            uuid_albums.append(id)

def gen_listeners():
    filename = CSV_DIRNAME + "/listeners.csv"
    t_row_count = RC_LISTENERS

    with open(filename, 'w', newline='') as csvfile:
        writer = csv.writer(csvfile, delimiter=',')

        for i in range(t_row_count):
            id = faker.unique.uuid4()
            writer.writerow([
                id,
                faker.name(),
                random.choice(genders),
                faker.date_of_birth(),
                faker.ascii_email(),
                faker.sha256()
                ])
            uuid_listeners.append(id)


def gen_rel_bands_cooperate_labels():
    filename = CSV_DIRNAME + "/rel_bands_cooperate_labels.csv"
    t_row_count = RC_REL_BCL

    with open(filename, 'w', newline='') as csvfile:
        writer = csv.writer(csvfile, delimiter=',')

        for i in range(t_row_count):
            date_s, date_e = faker.date(), faker.date()
            if date_s > date_e:
                date_s, date_e = date_e, date_s

            writer.writerow([
                faker.unique.uuid4(),
                random.choice(uuid_bands),
                random.choice(uuid_labels),
                date_s,
                date_e
                ])


def gen_rel_bands_sing_songs():
    filename = CSV_DIRNAME + "/rel_bands_sing_songs.csv"
    t_row_count = RC_REL_BSS

    with open(filename, 'w', newline='') as csvfile:
        writer = csv.writer(csvfile, delimiter=',')

        for i in range(t_row_count):
            writer.writerow([
                faker.unique.uuid4(),
                random.choice(uuid_bands),
                random.choice(uuid_songs),
                ])


def gen_rel_albums_contain_songs():
    filename = CSV_DIRNAME + "/rel_albums_contain_songs.csv"
    t_row_count = RC_REL_ACS

    with open(filename, 'w', newline='') as csvfile:
        writer = csv.writer(csvfile, delimiter=',')

        for i in range(t_row_count):
            writer.writerow([
                faker.unique.uuid4(),
                random.choice(uuid_albums),
                random.choice(uuid_songs)
                ])


def gen_rel_listeners_rate_songs():
    filename = CSV_DIRNAME + "/rel_listeners_rate_songs.csv"
    t_row_count = RC_REL_LRS

    with open(filename, 'w', newline='') as csvfile:
        writer = csv.writer(csvfile, delimiter=',')

        for i in range(t_row_count):
            writer.writerow([
                faker.unique.uuid4(),
                random.randint(1, 5),
                faker.date_time(),
                random.choice(uuid_songs),
                random.choice(uuid_listeners)
                ])

def gen_rel_listeners_comment_songs():
    filename = CSV_DIRNAME + "/rel_listeners_comment_songs.csv"
    t_row_count = RC_REL_LRS

    with open(filename, 'w', newline='') as csvfile:
        writer = csv.writer(csvfile, delimiter=',')

        for id_song in uuid_songs:

            parent_comment_count = random.randint(0, 10)
            for _ in range(parent_comment_count):
                available_ids = []

                id = faker.unique.uuid4()
                available_ids.append(id)

                writer.writerow([
                    id,  # id
                    faker.text(),  # text
                    'null',  # parent comment
                    faker.date_time(),  # timestamp
                    id_song,  # id song
                    random.choice(uuid_listeners)  # id listener
                    ])

                child_commnet_count = random.randint(0, 10)
                for _ in range(child_commnet_count):
                    id = faker.unique.uuid4()
                    available_ids.append(id)
                    writer.writerow([
                        id,  # id
                        faker.text(),  # text
                        random.choice(available_ids),  # parent comment
                        faker.date_time(),  # timestamp
                        id_song,  # id song
                        random.choice(uuid_listeners)  # id listener
                        ])


def main():
    create_csv_dir()

    gen_labels()
    gen_bands()
    gen_songs()
    gen_albums()
    gen_listeners()

    gen_rel_bands_cooperate_labels()
    gen_rel_bands_sing_songs()
    gen_rel_albums_contain_songs()
    gen_rel_listeners_rate_songs()
    gen_rel_listeners_comment_songs()


main()
