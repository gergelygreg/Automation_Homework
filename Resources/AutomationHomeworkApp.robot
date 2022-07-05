*** Settings ***
Library    DateTime
Library    Browser
Library    String
Variables    ../Resources/PO/locators.yaml
Resource    ../Data/InputData.robot

*** Variables ***
${EMAIL} =    testGergő@test.com

*** Keywords ***
Return Unique Email Address
  [Arguments]    ${prefix}=user    ${domain}=test.com

    ${unique}=    Get Current Date    result_format=epoch
    ${unique}=    Convert To Integer    ${unique * 1000}
    ${unique}=    Convert To String    ${unique}
    ${result}=    Set Variable    ${prefix}${unique}@${domain}

    [Return]    ${result}

#Test case: Successful registration
User is able to start registration
    #LandingPage
    Click    ${LandingPage["SignIn"]}
    #AuthenticationPage
    ${UNIQUE_EMAIL}=  Return Unique Email Address
    Type Text  ${AuthenticationPage["EmailCreate"]}    ${UNIQUE_EMAIL}
    Sleep    4s
    Click    ${AuthenticationPage["CreateAccountBtn"]}
    #CreateAnAccountPage
    Type text    ${CreateAnAccountPage["FirstName"]}    ${FIRST_NAME}
    Type text    ${CreateAnAccountPage["LastName"]}    ${LAST_NAME}
    Type text    ${CreateAnAccountPage["Password"]}    ${PASSWORD}
    Type text    ${CreateAnAccountPage["Address"]}    ${ADDRESS}
    Type text    ${CreateAnAccountPage["City"]}    ${CITY}
    Select options by  ${CreateAnAccountPage["State"]}  label  ${STATE}
    Type text  ${CreateAnAccountPage["Zip"]}  ${ZIP}
    Type text  ${CreateAnAccountPage["MobilePhone"]}    ${MOBILE_PHONE}
    Click  ${CreateAnAccountPage["RegisterBtn"]}

User is logged in after successful registration
    #MyAccountPage
    Get Text  ${MyAccountPage["UserNameLink"]}    ==    ${FIRST_NAME} ${LAST_NAME}
    Get Text  ${MyAccountPage["SignOutLink"]}  ==  Sign out

User is located on the 'My Account' page after registration
    #MyAccountPage
    Get Url  ==    http://automationpractice.com/index.php?controller=my-account
    ${MyAccountHeader}=    Get Text    ${MyAccountPage["MyAccountHeader"]}
    should be equal    ${MyAccountHeader}    MY ACCOUNT

#Test case: Searching for products
User is able to search products from the search bar on Home Page
    #LandingPage
    Type text  ${LandingPage["SearchBar"]}  blouse
    Click  ${LandingPage["SubmitSearchBtn"]}

User only sees items that match the entered search term
    ${SEARCH_TERM}=    Get Text    ${LandingPage["SearchTerm"]}
    should be equal  ${SEARCH_TERM}    "BLOUSE"

#Test case: Add products to cart from Popular tab on Home Page
User is able to add multiple items to the cart from the Popular tab on the Home Page
    Get url    equal  http://automationpractice.com/index.php
    Get classes  ${LandingPage["PopularLink"]}    ==    active
    Get classes  ${LandingPage["BestSellerLink"]}    !=    active
    Hover    ${LandingPage["FadedShortSleeveListItem"]}
    Click    ${LandingPage["FadedShortSleeveAddToCartBtn"]}
    Sleep    4s

User sees message that the item has been successfully added to the cart
    ${ITEM_COUNTER_MESSAGE}=    Get Text    ${LandingPage["ItemCounterMessage"]}
    should be equal  ${ITEM_COUNTER_MESSAGE}    There is 1 item in your cart.
    ${SUCCESSFULLY_ADDED_VERIFICATION_MESSAGE}=    Get text    ${LandingPage["SuccessfullyAddedVerificationMessage"]}
    should be equal  ${SUCCESSFULLY_ADDED_VERIFICATION_MESSAGE}    Product successfully added to your shopping cart
    Click    ${LandingPage["ContinueShoppingBtn"]}

User sees product count updating in the cart on the Home Page
    ${CART_QUANTITY_NUMBER}=    Get text  ${LandingPage["CartQuantity"]}
    should be equal  ${CART_QUANTITY_NUMBER}  1
    Hover   ${LandingPage["PrintedDressListItem"]}
    Click    ${LandingPage["PrintedDressAddToCartBtn"]}
    Sleep    4s
    Click    ${LandingPage["ContinueShoppingBtn"]}
    ${CART_QUANTITY_NUMBER}=    Get text  ${LandingPage["CartQuantity"]}
    should be equal  ${CART_QUANTITY_NUMBER}  2

Upon navigating to the cart user sees the same items in the cart that were previously added
    Click    ${LandingPage["CartLink"]}
    Sleep    4s
    Get url  equal  http://automationpractice.com/index.php?controller=order
    ${HEADER_VERIFICATION_TEXT_CART}=    Get text    ${SummaryPage["HeaderVerificationText"]}
    should be equal  ${HEADER_VERIFICATION_TEXT_CART}     Your shopping cart contains: 2 Products
    ${ITEM01}=    Get text   ${SummaryPage["FadedShortSleeveItem"]}
    should be equal  ${ITEM01}  Faded Short Sleeve T-shirts
    ${ITEM02}=    Get text  ${SummaryPage["PrintedDressItem"]}
    should be equal  ${ITEM02}  Printed Dress

User sees the same price of items that were previously added
    ${UNIT_PRICE_ITEM01}=    Get text  ${SummaryPage["FadedShortSleeveUnitPrice"]}
    should be equal  ${UNIT_PRICE_ITEM01}  ${UNIT_PRICE_FADED_SHORT_SLEEVE}
    ${UNIT_PRICE_ITEM02}=    Get text  ${SummaryPage["PrintedDressUnitPrice"]}
    should be equal  ${UNIT_PRICE_ITEM02}  ${UNIT_PRICE_PRINTED_DRESS}

#Test case: Delete from cart
User is able to delete items from the cart
    Hover    ${LandingPage["FadedShortSleeveListItem"]}
    Click    ${LandingPage["FadedShortSleeveAddToCartBtn"]}
    Sleep    4s
    Click    ${LandingPage["ContinueShoppingBtn"]}
    Hover   ${LandingPage["PrintedDressListItem"]}
    Click    ${LandingPage["PrintedDressAddToCartBtn"]}
    Sleep    4s
    Click    ${LandingPage["ProceedToCheckoutBtn"]}
    Get url  equal    http://automationpractice.com/index.php?controller=order
    ${TOTAL_PRICE}=    Get text    ${SummaryPage["TotalPrice"]}
    should be equal  ${TOTAL_PRICE}    ${TOTAL_PRICE01}

User sees the TOTAL price amount decreasing
    ${locator} =    Replace String    ${SummaryPage["IconTrash"]}    Index    2
    Click    ${locator}

    ${TOTAL_PRICE_AFTER_DELETION}=    Get text    ${SummaryPage["TotalPrice"]}
    should be equal  ${TOTAL_PRICE_AFTER_DELETION}    ${TOTAL_PRICE_AFTER_DELETION}
    should not be equal  ${TOTAL_PRICE_AFTER_DELETION}    $45.51

The reduction equals the price amount of the item that has been deleted
    ${TOTAL_PRICE_AFER_DELETION}=    Get text    ${SummaryPage["TotalPrice"]}
    should not be equal  ${TOTAL_PRICE_AFER_DELETION}    $45.51
    get element states    ${SummaryPage["FadedShortSleeveItem"]}    ${None}
    get element states  ${SummaryPage["PrintedDressItem"]}  ${None}

Whenever the last item is removed from the cart the page states that the shopping cart is empty
    ${locator} =    Replace String    ${SummaryPage["IconTrash"]}    Index    1
    Click    ${locator}
    ${ALERT_WARNING}=    Get text    ${SummaryPage["AlertWarning"]}
    should be equal  ${ALERT_WARNING}  Your shopping cart is empty.
    get element states    //span[@class='heading-counter']    ${None}

#Test case: Purchase products with bank wire
User is able to successfully purchase products that have been added to the cart with bank wire
    Hover    ${LandingPage["FadedShortSleeveListItem"]}
    Click    ${LandingPage["FadedShortSleeveAddToCartBtn"]}
    Sleep    4s
    Click    ${LandingPage["ContinueShoppingBtn"]}

    Hover    ${LandingPage["BlouseListItem"]}
    Click    ${LandingPage["BlouseAddToCartBtn"]}
    #Sleep    4s
    Click    ${LandingPage["ProceedToCheckoutBtn"]}

    Get url  equal    http://automationpractice.com/index.php?controller=order
    ${TOTAL_PRICE}=    Get text    ${SummaryPage["TotalPrice"]}
    should be equal  ${TOTAL_PRICE}    ${TOTAL_PRICE02}
    Click  ${SummaryPage["ProceedToCheckoutBtn"]}

    ${HEADER_VERIFICATION_TEXT}=    Get text    //h1[normalize-space()='Authentication']
    should be equal  ${HEADER_VERIFICATION_TEXT}     AUTHENTICATION
    Type text    ${AuthenticationPage["Email"]}    ${EMAIL}
    Type text    ${AuthenticationPage["Password"]}  ${PASSWORD}
    Click  ${AuthenticationPage["SignInBtn"]}
    Get url    equal    http://automationpractice.com/index.php?controller=order&step=1&multi-shipping=0
    ${HEADER_VERIFICATION_TEXT}=    Get text    ${LandingPage["Heading"]}
    should be equal  ${HEADER_VERIFICATION_TEXT}     ADDRESSES
    Click    ${AddressesPage["ProceedToCheckoutBtn"]}

    Get url    equal    http://automationpractice.com/index.php?controller=order
    ${HEADER_VERIFICATION_TEXT}=    Get text    ${LandingPage["Heading"]}
    should be equal  ${HEADER_VERIFICATION_TEXT}     SHIPPING
    Click    ${ShippingPage["TermsOfServiceCheckbox"]}
    Click    ${ShippingPage["ProceedToCheckoutBtn"]}
    #Sleep    4s
    Get url    equal    http://automationpractice.com/index.php?controller=order&multi-shipping=
    ${HEADER_VERIFICATION_TEXT}=    Get text    ${LandingPage["Heading"]}
    should be equal  ${HEADER_VERIFICATION_TEXT}     PLEASE CHOOSE YOUR PAYMENT METHOD
    Click    ${PaymentPage["PayByBankWire"]}

    get url    equal  http://automationpractice.com/index.php?fc=module&module=bankwire&controller=payment
    ${HEADER_VERIFICATION_TEXT}=    Get text    ${LandingPage["Heading"]}
    should be equal  ${HEADER_VERIFICATION_TEXT}     ORDER SUMMARY
    ${SUBHEADING_VERIFICATION_TEXT}=    Get text  ${LandingPage["Subheading"]}
    should be equal  ${SUBHEADING_VERIFICATION_TEXT}     BANK-WIRE PAYMENT.
    Click  //button[@class='button btn btn-default button-medium']
    #Sleep    4s
    ${HEADER_VERIFICATION_TEXT}=    Get text    ${LandingPage["Heading"]}
    should be equal  ${HEADER_VERIFICATION_TEXT}     ORDER CONFIRMATION
    Click    ${OrderConformationPage["BackToOrdersLink"]}
   # Sleep    4s

Upon order confirmation the order appears on the 'My Orders' page
    Get url  equal    http://automationpractice.com/index.php?controller=history
    ${HEADER_VERIFICATION_TEXT}=    Get text    //h1[@class='page-heading bottom-indent']
    should be equal  ${HEADER_VERIFICATION_TEXT}     ORDER HISTORY
    Get element    ${HistoryPage["Order"]}

#Test case: Order Reference after purchase
User sees the same 'order reference' that was given on order completion
    #Pre-condition
    Hover    ${LandingPage["FadedShortSleeveListItem"]}
    Click    ${LandingPage["FadedShortSleeveAddToCartBtn"]}
    Sleep    4s
    Click    ${LandingPage["ContinueShoppingBtn"]}

    Hover    ${LandingPage["BlouseListItem"]}
    Click    ${LandingPage["BlouseAddToCartBtn"]}
    Click    ${LandingPage["ProceedToCheckoutBtn"]}

    Get url  equal    http://automationpractice.com/index.php?controller=order
    ${TOTAL_PRICE}=    Get text    ${SummaryPage["TotalPrice"]}
    should be equal  ${TOTAL_PRICE}    ${TOTAL_PRICE02}
    Click  ${SummaryPage["ProceedToCheckoutBtn"]}

    ${HEADER_VERIFICATION_TEXT}=    Get text    //h1[normalize-space()='Authentication']
    should be equal  ${HEADER_VERIFICATION_TEXT}     AUTHENTICATION
    Type text    ${AuthenticationPage["Email"]}    ${EMAIL}
    Type text    ${AuthenticationPage["Password"]}  ${PASSWORD}
    Click  ${AuthenticationPage["SignInBtn"]}
    Get url    equal    http://automationpractice.com/index.php?controller=order&step=1&multi-shipping=0
    ${HEADER_VERIFICATION_TEXT}=    Get text    ${LandingPage["Heading"]}
    should be equal  ${HEADER_VERIFICATION_TEXT}     ADDRESSES
    Click    ${AddressesPage["ProceedToCheckoutBtn"]}

    Get url    equal    http://automationpractice.com/index.php?controller=order
    ${HEADER_VERIFICATION_TEXT}=    Get text    ${LandingPage["Heading"]}
    should be equal  ${HEADER_VERIFICATION_TEXT}     SHIPPING
    Click    ${ShippingPage["TermsOfServiceCheckbox"]}
    Click    ${ShippingPage["ProceedToCheckoutBtn"]}
    #Sleep    4s
    Get url    equal    http://automationpractice.com/index.php?controller=order&multi-shipping=
    ${HEADER_VERIFICATION_TEXT}=    Get text    ${LandingPage["Heading"]}
    should be equal  ${HEADER_VERIFICATION_TEXT}     PLEASE CHOOSE YOUR PAYMENT METHOD
    Click    ${PaymentPage["PayByBankWire"]}

    get url    equal  http://automationpractice.com/index.php?fc=module&module=bankwire&controller=payment
    ${HEADER_VERIFICATION_TEXT}=    Get text    ${LandingPage["Heading"]}
    should be equal  ${HEADER_VERIFICATION_TEXT}     ORDER SUMMARY
    ${SUBHEADING_VERIFICATION_TEXT}=    Get text    ${LandingPage["Subheading"]}
    should be equal  ${SUBHEADING_VERIFICATION_TEXT}     BANK-WIRE PAYMENT.
    Click    ${OrderSummaryPage["IConfirmMyOrderBtn"]}

    ${HEADER_VERIFICATION_TEXT}=    Get text    ${LandingPage["Heading"]}
    should be equal  ${HEADER_VERIFICATION_TEXT}     ORDER CONFIRMATION

    ${string} =    Get text    ${OrderConformationPage["OrderConformationText"]}
    @{list_string}=     split string    ${string}      ${SPACE}
    log    ${list_string}[36]

    Click    ${OrderConformationPage["BackToOrdersLink"]}

    #Test
    Get url  equal    http://automationpractice.com/index.php?controller=history
    ${ORDER_REFERENCE}=    Get text    ${HistoryPage["Order"]}
    Should Be Equal As Strings  ${list_string}[36]  ${ORDER_REFERENCE}

