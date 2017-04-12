# Math Battle Solver by MohamadKh75
# 2017-04-12
# ********************

from selenium.webdriver import Chrome
from pathlib import Path
import keyboard


print("Press 'Esc' anytime to quit!\n")

# Set the driver path (Needed for controlling the browser)!
web_driver_path = Path("chromedriver_win32_2.29\chromedriver.exe").resolve()

# Set the url of the game and open it in the browser!
url = "https://tbot.xyz/math/"
browser = Chrome(str(web_driver_path))
browser.get(url)

# Start the game and define the Correct and Wrong buttons!
button = browser.find_element_by_id("button_correct")
button.click()
correct_button = browser.find_element_by_id("button_correct")
wrong_button = browser.find_element_by_id("button_wrong")


print("Let's Go!\n")

while True:

    # Read the source of the page for gathering the Operands and Operator!
    x = int(browser.find_element_by_id("task_x").text.strip())
    y = int(browser.find_element_by_id("task_y").text.strip())
    operator = browser.find_element_by_id("task_op").text
    result = int(browser.find_element_by_id("task_res").text.strip())

    # Calculate the correct result of the math shown!
    real_result = 0
    if operator == '+':
        real_result = x + y

    elif operator == '–':
        real_result = x - y

    elif operator == '×':
        real_result = x * y

    elif operator == '/':
        real_result = x / y

    # Check if the answer is True or not!
    if result == real_result:
        correct_button.click()
    else:
        wrong_button.click()

    # How to exit from the program!
    state = keyboard.is_pressed('esc')
    if state == 1:
        print("Good Luck Buddy!")
        exit()
