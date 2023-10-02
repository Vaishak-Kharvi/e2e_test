Feature: Validate google title

  @test_run
  Scenario: User validates title 1
    Given User launches browser and navigates to "Google"
    When User validates "Google" title
    Then Then close the browser

  @test_run
  Scenario: User validates title 2
    Given User launches browser and navigates to "GitHub"
    When User validates "GitHub" title
    Then Then close the browser

  @test_run
  Scenario: User validates title 3
    Given User launches browser and navigates to "YouTube"
    When User validates "YouTube" title
    Then Then close the browser
