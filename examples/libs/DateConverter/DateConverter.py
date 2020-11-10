import datetime
from robot.api.deco import keyword


class DateConverter:
    """
    Converts dates based on today's date
    """
    def __init__(self):
        self.current_date = datetime.date.today()

    @keyword(name="Get Date From Future")
    def get_date_from_future(self, days):
        """
        :param days: Amount of days we want to advance as an interger
        :return: A date in dd.mm.yyyy format
        """
        date = self.current_date + datetime.timedelta(int(days))
        return str(date.day) + "." + str(date.month) + "." + str(date.year)

    @keyword(name="Date Is In Next Month")
    def date_is_in_next_month(self, date):
        """
        Checks the given date and compares if it's in a following month
        :param date: Date we want to compare
        :return: True if given date is in next month, False otherwise
        """
        wanted_date = datetime.datetime.strptime(date, "%d.%m.%Y")
        return wanted_date.month > self.current_date.month

    @keyword(name="Parse Day From Date")
    def parse_day_from_date(self, strdate):
        """
        :param strdate: Date as a string
        :return: The "day" portion of dd.mm.yyyy format
        """
        return strdate.split(".")[0]
