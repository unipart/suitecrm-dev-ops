<?php
/**
 * Created by PhpStorm.
 * User: Riccardo De Leo
 */

/**
 * Defines application features from the specific context.
 */
class FeaturesContext extends WaitContext
{
    /**
     * @var string
     */
    static private $salt = '9D6KAFNHTM68UM5FH4J2J3K6ZFGQVNDF6';

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

    /**
     * @When I click on id :arg1
     */
    public function iClickOnId($arg1)
    {
        $this
            ->getSession()
            ->getPage()
            ->find('css', '#' . $arg1)
            ->click();
    }

}
