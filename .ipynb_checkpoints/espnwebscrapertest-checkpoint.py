from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.chrome.options import Options
import chromedriver_autoinstaller

chromedriver_autoinstaller.install()

options = Options()
options.headless = True


nba_schedule = 'https://www.espn.com/nba/schedule'
driver = webdriver.Chrome(options = options)
driver.get(nba_schedule)

nba_date = driver.find_element(By.CLASS_NAME, 'Table__Title') #Prints current date from NFL schedule
print(nba_date.text)
driver.close()