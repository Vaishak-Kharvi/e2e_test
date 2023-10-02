import os

import pytest
from pytest_bdd import given, then, scenarios, when
from pytest_bdd.parsers import parse
from pyvirtualdisplay import Display
from selenium import webdriver
from webdriver_manager.chrome import ChromeDriverManager

scenarios(os.getcwd() + '/Features/google.feature')


# def test_user_validates_google_title():
#     """User validates google title."""
#     print("User validates google title.")

@pytest.fixture
def driver():
    # display = Display(visible=0, size=(800, 800))
    # display.start()
    options = webdriver.ChromeOptions()
    options.add_argument("--disable-dev-shm-usage")
    driver = webdriver.Remote(command_executor='http://selenium-hub:4444/wd/hub',options=options)
    driver.implicitly_wait(30)
    # driver = webdriver.Chrome(ChromeDriverManager().install())
    # driver.maximize_window()
    return driver


@given(parse('User launches browser and navigates to "{page}"'))
def test_user_launches_browser(driver, page):
    """User launches browser."""
    url = None
    if page == 'Google':
        url = 'http://google.com'
    elif page == 'GitHub':
        url = 'https://github.com/'
    elif page == 'YouTube':
        url = 'https://www.youtube.com/'
    print(url)
    driver.get(url)
    print("User launches browser.")


@when(parse('User validates "{page}" title'))
def test_title(driver, page):
    title = driver.title
    if page == 'Google':
        assert title == 'Google', "title mismatch"
    elif page == 'GitHub':
        assert title == 'GitHub: Let’s build from here · GitHub', "title mismatch"
    elif page == 'YouTube':
        assert title == 'YouTube', "title mismatch"

@then('Then close the browser')
def test_close_browser(driver):
    driver.close()
