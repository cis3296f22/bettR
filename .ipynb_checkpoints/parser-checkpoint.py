import csv
from urllib.parse import quote
from selenium import webdriver
from selenium.webdriver.chrome.options import Options

from bs4 import BeautifulSoup, NavigableString
from enum import Enum


class Sorting(Enum):
    FEATURED = 'relevanceblender'
    LOW_TO_HIGH = 'price-asc-rank1'
    HIGH_TO_LOW = 'price-desc-rank'
    AVG_REVIEW = 'review-rank'
    NEWEST = 'date-desc-rank'


class ResultItem:
    def __init__(self, title, url, img_ref, star_count, review_count, price, is_free_shipping, shipping_price, limited_stock, additional_buy_options):
        self.title = title
        self.url = url
        self.img_ref = img_ref
        self.star_count = star_count
        self.review_count = review_count
        self.price = price
        self.is_free_shipping = is_free_shipping
        self.shipping_price = shipping_price
        self.limited_stock = limited_stock
        self.additional_buy_options = additional_buy_options


# User configurable

# True - loads from local files, False - loads from internet
debug = True
# The search term
query = 'temple university hat'
# location to save csv
csv_save_dir = '/Users/aruna/Downloads/' + query + '.csv'
# sorting option to be passed
sorting = Sorting.AVG_REVIEW

# internal globals
html_string = ''
base_url = 'https://www.amazon.com/s'
items = []
page_no = 1
max_page = 1

# Note: if you wish to run this program locally you will have to download Gecko Driver and change the path
# Geckodriver is a Selenium driver for Firefox that allows it to interface with Python and fetch pages
# This is required because many sites (like Amazon) take steps to ensure automated programs can't scrape their site
# https://github.com/mozilla/geckodriver/releases

driver_path = '/Users/aruna/Downloads/geckodriver'


def parse_rows(results):
    i = 0

    for row_div in results.children:
        # ignores blank string lines
        if type(row_div) is NavigableString:
            continue
        # ignores amazon recommended rows with multiple products or editiorals and non-product the div at the bottom
        if 'SHOPPING_ADVISER' in str(row_div) or len(str(row_div)) < 100:
            continue

        try:
            title_header = row_div.h2
            title_string = title_header.span.string
            title_link = 'https://amazon.com' + title_header.a.get('href')
            img_url = row_div.img['srcset'].replace(',', '').split()
            star_count = row_div.find('span', 'a-icon-alt')
            review_count = ''
            price_str = row_div.find('span', 'a-offscreen')
            explicit_free_shipping = len(list(filter(lambda x: 'free shipping' in str(x).lower(), list(row_div.span)))) > 0
            is_prime = row_div.find('i', 'a-icon-prime') is not None
            free_shipping = explicit_free_shipping or is_prime
            limited_stock = row_div.find('span', 'a-color-price')
            ship_cost = None
            addl_buying_choices = 'More Buying Choices' in str(row_div)

            # populate values that could be None
            if not free_shipping:
                span_list = list(filter(lambda x: 'shipping' in str(x).lower(),
                                        list(row_div.find_all('span', {'dir': 'auto'}))))
                if len(span_list) > 0:
                    ship_cost = span_list[0].string.split()[0]

            if star_count is not None:
                star_count = star_count.string.split(' ')[0]

            if price_str is not None:
                price_str = price_str.string

            if limited_stock is not None:
                limited_stock = limited_stock.string.split()[1]

            # creates a dict of image urls by resolution and returns highest res
            last_img_url = ''
            img_urls = {}
            for item in img_url:
                if last_img_url == '':
                    last_img_url = item
                else:
                    img_urls[item] = last_img_url
                    last_img_url = ''
            img_urls = list(img_urls.values())[-1]

            # set review count to the tag contents that can be converted to int
            for tag in row_div.find_all('span', {'class': 'a-size-base', 'dir': 'auto'}):
                try:
                    review_count = int(tag.string.replace(',', ''))
                except:
                    continue

            print(title_string)
            # print(title_link)
            # print(img_urls)
            # print(star_count)
            # print(review_count)
            # print(price_str)
            # print(free_shipping)
            # print(ship_cost)
            # print(limited_stock)
            # print(addl_buying_choices)
            print('-----------------')

            item = ResultItem(title_string, title_link, img_urls, star_count, review_count, price_str, free_shipping,
                              ship_cost, limited_stock, addl_buying_choices)
            items.append(item)

        except Exception as e:
            print("ERROR")
            print(e.with_traceback())
            print(title_string)
            i += 1
    print(f'{i} items dropped due to parsing error')


# Creates a headless firefox instance to open and return page contents
def get_internet_html(fetch_url):
    options = Options()
    options.headless = True
    driver = webdriver.Firefox(options=options, executable_path=driver_path)
    driver.get(fetch_url)
    contents = str(driver.page_source)
    driver.quit()

    return contents


def load_html():
    global max_page
    global page_no
    global html_string

    files = []

    if debug:
        # Add local files to open
        for i in range(1, 21):
            files.append(f'/Users/aruna/Downloads/hd%20tv{i}.html')
        max_page = len(files)
    else:
        while True:
            # if last page end loop
            if page_no > max_page:
                break

            # construct url
            fetch_url = base_url + '?k=' + quote(query) + "&page=" + str(page_no) + "&s=" + str(sorting.value)
            print(fetch_url)

            # fetch page data and save to file
            page = get_internet_html(fetch_url)
            file_str = '/Users/aruna/Downloads/' + quote(query) + str(page_no) + '.html'
            files.append(file_str)
            file = open(file_str, 'w')
            file.write(page)
            file.close()

            # if first time through loop get number of pages total
            if page_no == 1:
                page_soup = BeautifulSoup(open(file_str, 'r').read(), 'html.parser')
                try:
                    max_page = int(list(page_soup.find_all('li', 'a-disabled'))[1].string)
                except:
                    max_page = 1
                print(f'Getting {max_page} pages')

            page_no += 1

    # read saved files and parse results into objects
    for file_str in files:
        html_string = open(file_str, 'r').read()
        page_soup = BeautifulSoup(html_string, 'html.parser')
        results = page_soup.find('div', 's-search-results')
        parse_rows(results)


# Writes parsed objects in the items var to csv
def save_objects():
    with open(csv_save_dir, 'w') as save_file:
        writer = csv.DictWriter(save_file, fieldnames=items[0].__dict__.keys())
        writer.writeheader()
        for row in items:
            writer.writerow(row.__dict__)


def main():
    load_html()
    save_objects()


if __name__ == '__main__':
    main()