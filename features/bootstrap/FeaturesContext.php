<?php

use Behat\Behat\Tester\Exception\PendingException;
use Behat\MinkExtension\Context\MinkContext;
use PHPUnit\Framework\TestCase;


/**
 * Defines application features from the specific context.
 */
class FeaturesContext extends MinkContext
{
    static private $salt = '9D6KAFNHTM68UM5FH4J2J3K6ZFGQVNDF6';

    /**
     * @Given I wait milliseconds :arg1
     */
    public function iWaitMilliseconds($arg1)
    {
        $this
            ->getSession()
            ->wait($arg1);
        return;
    }

    /**
     * @When I click on the element :arg1 within the element id :arg2
     */
    public function iClickOnTheElementWithinTheElementId($arg1, $arg2)
    {
        $this
            ->getSession()
            ->getPage()
            ->find('css', '#' . $arg2 . ' ' .$arg1)
            ->click();
    }

}
