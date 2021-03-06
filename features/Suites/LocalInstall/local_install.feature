Feature: Perform local installation
  In order to use SuiteCRM
  As a developer or a tester
  I need to perform a fresh installation

  Scenario: Install successfully SuiteCRM
    Given I am on "/"
    Then I wait till "50000" or to see "Next"
    And I check "setup_license_accept"
    And I wait milliseconds "500"
    And I press "Next"
    And I wait till "50000" or to see "System Environment"
    And I press "Next"
    And I wait till "50000" or to see "Site Security"
    And I select "provide" from "dbUSRData"
    And I wait milliseconds "1000"
    And I fill in the following:
      | setup_db_host_name  | mariadb   |
      | setup_db_sugarsales_user  | suitecrm_user   |
      | setup_db_sugarsales_password_entry  | suitecrmdevpass   |
      | setup_db_sugarsales_password_retype_entry  | suitecrmdevpass   |
      | setup_site_admin_password  | admin1234   |
      | setup_site_admin_password_retype  | admin1234   |
      | setup_site_url  | http://app:8080   |
      | email1  | admin@crm-server.lan   |
    And I wait milliseconds "1000"
    And I click on the element "h3" within the element id "fb4"
    And I wait milliseconds "1000"
    And I select "Y-m-d" from "default_date_format"
    And I select "Europe/London" from "timezone"
    And I fill in the following:
      | default_currency_name | British Pounds |
      | default_currency_symbol  | £   |
      | default_currency_iso4217  | GBP   |
    And I press "Next"
    And I wait till "50000" or to see "is now complete!"
    When I press "Next"
    Then I wait till "50000" or to see "Supercharged by SuiteCRM"
