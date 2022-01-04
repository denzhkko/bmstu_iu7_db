##############################################################################
# РК 03
# ИУ7-53Б
# Недолужко Денис
# Вариант 4

import peewee as pw
from playhouse.shortcuts import Cast

db = pw.PostgresqlDatabase('rk_03', user='postgres', password='postgres',
                           host='localhost', port=5432)

class BaseModel(pw.Model):
    """A base model that will use our Postgresql database"""
    class Meta:
        database = db

class Employee(BaseModel):
    id = pw.PrimaryKeyField()
    name = pw.TextField()
    birth = pw.DateField()
    dep = pw.TextField()


class Arrival(BaseModel):
    id = pw.PrimaryKeyField()
    id_emp = pw.ForeignKeyField(Employee, on_delete="cascade")
    date = pw.DateField()
    weekday = pw.TextField()
    time = pw.TimeField()
    type = pw.IntegerField()


def task_01():
    cursor = Employee.select(Employee.id, Employee.name).join(Arrival).where(
        Arrival.date == "2018-12-14",
        Arrival.type == 1,
        pw.fn.Date_part('minute', Arrival.time.cast("time") - Cast("9:00", "time"))
    )
    for row in cursor:
        print(row)

def task_02():
    pass

def task_03():
    cursor = Employee.select(Employee.id, Employee.fio).join(Arrival).where(
        Employee.dep == "Бухгалтерия",
        Arrival.type == 1,
        Arrival.time < Cast("8:00", "time")
    )
    for row in cursor:
        print(row)


def main():
    task_01()
    task_02()
    task_03()


if __name__ == "__main__":
    main()
