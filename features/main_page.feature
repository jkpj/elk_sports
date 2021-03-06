Feature: Main page
  In order to start using the service
  As a user
  I want to access the service main page

  Scenario: Load main page
    Given I go to the home page
    Then I should see "Hirvenhiihdon ja hirvenjuoksun tulospalvelu" within ".main_title"
    And I should see "Hirviurheilu on hirvenhiihdon ja hirvenjuoksun helppokäyttöinen tulospalvelu."
    And I should see "Tutustu lukemalla lisää Info-sivulta ja katsomalla Youtube-video."
    When I follow "Info-sivulta"
    Then I should be on the info page

  Scenario: Listing races in the main page
    Given there is a race with attributes:
      | name | Old race |
      | start_date | 2010-01-01 |
      | end_date | 2010-01-02 |
      | location | Old city |
    And there is a race with attributes:
      | name | Upcoming race |
      | start_date | 2020-01-01 |
      | end_date | 2020-01-02 |
      | location | Upcoming city |
    And there is an ongoing race with attributes:
      | name | Ongoing race |
      | location | Ongoing city |
    And I go to the home page
    Then I should see "Päättyneet kilpailut" within "div.old_races"
    And I should see "Old race" within "div.old_races"
    And I should see "01.01.2010 - 02.01.2010, Old city" within "div.old_races"
    And I should see "Tulevat kilpailut" within "div.future_races"
    And I should see "Upcoming race" within "div.future_races"
    And I should see "01.01.2020 - 02.01.2020, Upcoming city" within "div.future_races"
    And I should see "Kilpailut tänään" within "div.ongoing_races"
    And I should see "Ongoing race" within "div.ongoing_races"
    And I should see "Ongoing city" within "div.ongoing_races"

  Scenario: No races
    Given I go to the home page
    Then I should see "Tulevat kilpailut" within "div.future_races"
    And I should see "Tällä hetkellä ei tiedossa tulevia kilpailuita" within "div.future_races"
    But I should not see "Kilpailut tänään"
    And I should not see "Päättyneet kilpailut"

  Scenario: Showing registration link for unauthenticated users
    Given I am on the home page
    Then I should see "Oletko järjestämässä hirvenhiihdon tai hirvenjuoksun kilpailua?"
    When I follow "Aloita tästä."
    Then I should be on the registration page

  Scenario: No registration link for authenticated users
    Given I am an official
    And I have logged in
    And I am on the home page
    Then I should not see "Oletko järjestämässä hirvenhiihdon tai hirvenjuoksun kilpailua?"
    And I should not see "Aloita tästä."

  Scenario: Showing login link for unauthenticated users
    Given I am on the home page
    Then I should see "Onko sinulla jo tunnukset?"
    When I follow "Kirjaudu sisään."
    Then I should be on the login page

  Scenario: No login link for authenticated users
    Given I am an official
    And I have logged in
    And I am on the home page
    Then I should not see "Onko sinulla jo tunnukset?"
    And I should not see "Kirjaudu sisään."
