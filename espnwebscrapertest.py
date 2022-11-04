from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.chrome.options import Options
import chromedriver_autoinstaller

chromedriver_autoinstaller.install()

options = Options()
options.headless = True


nfl_schedule = 'https://www.espn.com/nfl/schedule'
driver = webdriver.Chrome(options = options)
driver.get(nfl_schedule)

nfl_date = driver.find_element(By.CLASS_NAME, 'Table__Title') #Prints current date from NFL schedule
print(nfl_date.text)
driver.close()