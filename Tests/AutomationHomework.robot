*** Settings ***
Documentation    Testing of functions of "http://automationpractice.com/index.php?" website
Resource    ..//Resources/Common.robot
Resource    ..//Resources/AutomationHomeworkApp.robot

Test Setup    Prepare test case
Test Teardown    End test case

*** Test Cases ***
Successful registration
    [Tags]    Registration
    User is able to start registration
    User is logged in after successful registration
    User is located on the 'My Account' page after registration

Searching for products
    [Tags]    Search
    User is able to search products from the search bar on Home Page
    User only sees items that match the entered search term

Add products to cart from Popular tab on Home Page
    [Tags]    Add to cart
    User is able to add multiple items to the cart from the Popular tab on the Home Page
    User sees message that the item has been successfully added to the cart
    User sees product count updating in the cart on the Home Page
    Upon navigating to the cart user sees the same items in the cart that were previously added
    User sees the same price of items that were previously added

Delete products from cart
    [Tags]    Delete from cart
    User is able to delete items from the cart
    User sees the TOTAL price amount decreasing
    The reduction equals the price amount of the item that has been deleted
    Whenever the last item is removed from the cart the page states that the shopping cart is empty

Purchase products with bank wire
    [Tags]    Purchase
    User is able to successfully purchase products that have been added to the cart with bank wire
    Upon order confirmation the order appears on the 'My Orders' page

Order Reference after purchase
    [Tags]  Order reference
    User sees the same 'order reference' that was given on order completion
