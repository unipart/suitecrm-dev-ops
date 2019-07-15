Feature: Post local install
  In order to use SuiteCRM
  As a developer or a tester
  I need to perform some post install fine tuning

  Scenario: Enable developer mode
    Given I am on "/index.php?module=Configurator&action=EditView"
    And I wait milliseconds "1000"
    And I check "developerMode"
    And I fill in "list_max_entries_per_page" with "21"
    And I fill in "list_max_entries_per_page" with "20"
    When I press "Save"
    Then I wait till "30000" or to see "ADMINISTRATION"